class Domain < ApplicationRecord
  has_many :domain_entries, inverse_of: :domain
  accepts_nested_attributes_for :domain_entries
  validate :includes_all_domain_entries

  after_save :invalidate_hash_cache

  def self.create_from_params(params, training_log)
    training_options = training_log.transformed_data
    domain_entries_attributes = []
    params['training_log'].each do |data_type, selected_option|
      val = if %w(css xpath).include?(selected_option['option'])
        {
          pattern: selected_option[selected_option['option']],
          method: selected_option['option'],
          data_type: data_type
        }
      else
        {
          pattern: training_options[data_type][selected_option['option']]['pattern'],
          method: training_options[data_type][selected_option['option']]['method'],
          data_type: data_type
        }
      end
      domain_entries_attributes << val
    end
    Domain.create(root_domain: training_log.root_domain, domain_entries_attributes: domain_entries_attributes)
  end

  def self.hash
    Rails.cache.fetch('domains_hash') do
      Domain.includes(:domain_entries).all.each_with_object({}) do |domain, domains_hash|
        domains_hash[domain.root_domain] = domain.domain_entries.each_with_object({}) do |entry, hash|
          hash[entry.data_type] = {
            'method' => entry.method,
            'pattern' => entry.pattern
          }
        end
      end
    end
  end

  def self.load_from_gem
    NewsScraper.configuration.scrape_patterns['domains'].each do |root_domain, data_types|
      next if Domain.exists?(root_domain: root_domain)
      Rails.logger.info "[DOMAINS] Creating domain entry for #{root_domain}"
      domain_entries_attributes = data_types.each_with_object([]) do |(data_type, data_type_hash), acc|
        acc << { data_type: data_type }.merge(data_type_hash)
      end
      Domain.create!(root_domain: root_domain, domain_entries_attributes: domain_entries_attributes)
    end
  end

  private

  def invalidate_hash_cache
    Rails.cache.delete('domains_hash')
  end

  def includes_all_domain_entries
    data_types = NewsScraper.configuration.scrape_patterns['data_types']
    missing_data_types = data_types - domain_entries.collect(&:data_type)
    errors.add(
      'domain.domain_entries',
      "Missing domain entries for #{missing_data_types.to_sentence}"
    ) unless missing_data_types.empty?
  end
end
