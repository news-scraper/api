require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  test 'hash is formatted correctly' do
    domain_entries = {
      'author' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'body' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'description' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'keywords' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'section' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'datetime' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'title' => {
        'method' => 'css',
        'pattern' => '.div'
      },
    }
    assert_equal({
      'google.ca' => domain_entries,
      'google.com' => domain_entries
    }, Domain.hash)
  end

  test 'hash is cached' do
    Domain.hash # populate the cache

    domain_entries = {
      'author' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'body' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'description' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'keywords' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'section' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'datetime' => {
        'method' => 'css',
        'pattern' => '.div'
      },
      'title' => {
        'method' => 'css',
        'pattern' => '.div'
      },
    }
    assert_equal({
      'google.ca' => domain_entries,
      'google.com' => domain_entries
    }, Rails.cache.fetch('domains_hash'))
  end

  test 'saving a domain invalidates the cache' do
    Domain.hash # populate the cache
    Domain.first.update(root_domain: 'google.jp')
    assert_nil Rails.cache.fetch('domains_hash')
  end

  test 'load_from_gem loads domains and entries from the gem' do
    data_types = NewsScraper.configuration.scrape_patterns['data_types']
    domains = NewsScraper.configuration.scrape_patterns['domains']

    assert_difference 'DomainEntry.count', domains.count * data_types.count do
      assert_difference 'Domain.count', domains.count do
        Domain.load_from_gem
      end
    end
  end
end
