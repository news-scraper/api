# Load any new domains from the gem before overriding the scrape_patterns_fetch_method
if Domain.table_exists? && DomainEntry.table_exists?
  NewsScraper.configuration.scrape_patterns['domains'].each do |root_domain, data_types|
    next if Domain.exists?(root_domain: root_domain)
    Rails.logger.info "[DOMAINS] Creating domain entry for #{root_domain}"
    domain_entries_attributes = data_types.each_with_object([]) do |(data_type, data_type_hash), acc|
      acc << { data_type: data_type }.merge(data_type_hash)
    end
    Domain.create!(root_domain: root_domain, domain_entries_attributes: domain_entries_attributes)
  end
end

# Set the scrape_patterns_fetch_method, this will be called for any scrape
# but makes live DB calls, so it means our config is always up to date
@default_configuration = NewsScraper.configuration.scrape_patterns.dup

NewsScraper.configure do |config|
  config.scrape_patterns_fetch_method = proc do
    configuration = @default_configuration.dup

    # Override domains
    configuration['domains'] = Domain.domain_hash

    # Add to Presets
    data_type_hashes = DomainEntry.all.group_by(&:data_type) || {}
    @default_configuration['data_types'].each do |dt|
      gem_presets = @default_configuration['presets'][dt].dup
      db_presets = data_type_hashes[dt].each_with_object({}) do |entry, acc|
        should_add = !gem_presets.any? { |_, v| v['pattern'] == entry.pattern || entry.pattern.blank? } &&
                     !acc.any? { |_, v| v['pattern'] == entry.pattern || entry.pattern.blank? }
        acc[entry.id.to_s] = entry.to_h if should_add
      end
      configuration['presets'][dt] = gem_presets.merge(db_presets)
    end

    configuration
  end
end
