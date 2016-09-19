class Domain < ApplicationRecord
  has_many :domain_entries, inverse_of: :domain
  accepts_nested_attributes_for :domain_entries
  validate :includes_all_domain_entries

  after_save :invalidate_hash_cache

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
