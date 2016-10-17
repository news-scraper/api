module TrainingFlow
  extend ActiveSupport::Concern

  def transformed_data
    data = Api::Application::Redis.get(transformed_data_redis_key)
    return JSON.parse(data) if data.present?

    data = fetch_transformed_data
    completeness = num_options_predefined.to_f / num_options_available
    update_attributes(completeness: completeness)
    attempt_to_automatically_train if completeness == 1.0
    data
  end

  def num_options_predefined
    transformed_data.except('url', 'root_domain').sum do |_, options|
      options.any? { |_, vals| vals['data'].present? } ? 1 : 0
    end
  end

  def num_options_available
    transformed_data.except('url', 'root_domain').keys.count
  end

  def clear_transformed_data!
    Api::Application::Redis.set(transformed_data_redis_key, nil)
  end

  private

  def fetch_transformed_data
    data = NewsScraper::Transformers::TrainerArticle.new(
      url: url,
      payload: http_request(url).body
    ).transform

    Api::Application::Redis.set(transformed_data_redis_key, data.to_json)
    data
  end

  def attempt_to_automatically_train
    domain_entries = best_options_for_domain_entries
    return unless domain_entries

    domain = Domain.create(root_domain: root_domain, domain_entries_attributes: domain_entries)
    TrainingLog.train!(root_domain) if domain.persisted?
  end

  def best_options_for_domain_entries
    transformed_data.except('url', 'root_domain').each_with_object([]) do |(option, options), best_options|
      best_option = choose_best_option(option, options)
      return nil unless best_option # If any of them doesn't have a best option, then bail
      best_options << {
        data_type: option,
        pattern: best_option['pattern'],
        method: best_option['method']
      }
    end
  end

  def choose_best_option(option, options)
    case option.to_s.downcase
    when 'author'
      # remove and for ,
      # remove by at the beginning
      data_options = options.collect do |_, o|
        o['data'].gsub('and', ',').gsub(/^by /i, '')
      end

      # Select the one with given names and family names according to Namae
      # And has less than or has 4 words
      _, idx = data_options.each_with_index.to_a.select do |s, _|
        next if s.blank?

        n = Namae.parse(s)
        s.split(' ').size <= 4 && n.all?(&:given) && n.all?(&:family)
      end.first

      return nil unless idx
      options[options.keys[idx]]
    when 'body'
      # Always go for readability
      options['readability']
    when 'description'
      # Choose the "best description" from metainspector first
      # Then default to og description, as it usually more concise
      # Then default back to meta description
      return options['metainspector'] if options.key?('metainspector') && options['metainspector']['data'].present?
      return options['og'] if options.key?('og') && options['og']['data'].present?
      return options['meta'] if options.key?('meta') && options['meta']['data'].present?
    when 'keywords'
      begin
        # Choose the one with the most keywords
        max, idx = options.collect { |_, o| o['data'].split(',') }.each_with_index.max
        return nil if max.size < 2
        options[options.keys[idx]]
      rescue ArgumentError
        Rails.logger.info "Issues with #{id}"
        return nil
      end
    when 'section'
      return options['meta'] if options['meta']['data'].present?
      return options['section'] if options['section']['data'].present?
      { "method" => "xpath", "pattern" => "//meta[@property='og:type']/@content" }
    when 'title'
      # Choose the "best title" from metainspector first
      # Then default to og title, as it usually doesn't include the site name
      # Then default back to html title
      return options['metainspector'] if options.key?('metainspector') && options['metainspector']['data'].present?
      return options['og'] if options.key?('og') && options['og']['data'].present?
      return options['html'] if options.key?('html') && options['html']['data'].present?
    when 'datetime'
      begin
        # Choose the first one which parses properly
        opt = options.detect { |_, o| Time.zone.parse(o['data']) }
        return nil unless opt
        opt.last
      rescue
        false
      end
    end
  end

  def transformed_data_redis_key
    "training-#{id}-transformed"
  end
end
