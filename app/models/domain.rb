class Domain < ApplicationRecord
  has_many :domain_entries, inverse_of: :domain
  accepts_nested_attributes_for :domain_entries
  validate :includes_all_domain_entries

  private

  def includes_all_domain_entries
    data_types = NewsScraper.configuration.scrape_patterns['data_types']
    missing_data_types = data_types - domain_entries.collect(&:data_type)
    errors.add(
      'domain.domain_entries',
      "Missing domain entries for #{missing_data_types.to_sentence}"
    ) unless missing_data_types.empty?
  end
end
