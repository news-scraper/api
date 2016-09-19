NewsScraper.configuration.scrape_patterns['domains'].each do |root_domain, data_types|
  next if Domain.exists?(root_domain: root_domain)

  Rails.logger.info "[DOMAINS] Creating domain entry for #{root_domain}"
  domain_entries_attributes = data_types.each_with_object([]) do |(data_type, data_type_hash), acc|
    acc << { data_type: data_type }.merge(data_type_hash)
  end
  Domain.create!(root_domain: root_domain, domain_entries_attributes: domain_entries_attributes)
end
