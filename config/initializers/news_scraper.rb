# Load any new domains from the gem before overriding the fetch_method
if Domain.table_exists?
  NewsScraper.configuration.scrape_patterns['domains'].each do |root_domain, data_types|
    next if Domain.exists?(root_domain: root_domain)
    Rails.logger.info "[DOMAINS] Creating domain entry for #{root_domain}"
    domain_entries_attributes = data_types.each_with_object([]) do |(data_type, data_type_hash), acc|
      acc << { data_type: data_type }.merge(data_type_hash)
    end
    Domain.create!(root_domain: root_domain, domain_entries_attributes: domain_entries_attributes)
  end
end

@default_configuration = NewsScraper.configuration.scrape_patterns.dup
NewsScraper.configure do |config|
  config.fetch_method = proc do
    @default_configuration['domains'] = Domain.domain_hash
    @default_configuration
  end
end
