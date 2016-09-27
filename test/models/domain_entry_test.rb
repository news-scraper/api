require 'test_helper'

class DomainEntryTest < ActiveSupport::TestCase
  test 'validate_pattern catches malformed xpath' do
    d = DomainEntry.new(
      domain: domains(:one),
      data_type: 'body',
      method: 'xpath',
      pattern: '//div[@class="missing-quote]'
    )
    refute d.valid?
    expected_msg = "Pattern (//div[@class=\"missing-quote]) was not well formed for data_type body.\n"\
      "Nokogiri::XML::XPath::SyntaxError: Unfinished literal: (//div[@class=\"missing-quote])[1]"
    assert_equal [expected_msg], d.errors.full_messages

    d2 = DomainEntry.new(
      domain: domains(:one),
      data_type: 'body',
      method: 'xpath',
      pattern: '//div[@class="missing-bracket"'
    )
    refute d2.valid?
    expected_msg = "Pattern (//div[@class=\"missing-bracket\") was not well formed for data_type body.\n"\
      "Nokogiri::XML::XPath::SyntaxError: Invalid predicate: (//div[@class=\"missing-bracket\")[1]"
    assert_equal [expected_msg], d2.errors.full_messages
  end

  test 'validate_pattern catches malformed css' do
    d = DomainEntry.new(
      domain: domains(:one),
      data_type: 'body',
      method: 'css',
      pattern: '. ihaveaspace'
    )
    refute d.valid?
    expected_msg = "Pattern (. ihaveaspace) was not well formed for data_type body.\n"\
      "Nokogiri::CSS::SyntaxError: unexpected ' ' after '.'"
    assert_equal [expected_msg], d.errors.full_messages

    d2 = DomainEntry.new(
      domain: domains(:one),
      data_type: 'body',
      method: 'css',
      pattern: '..toomanyperiods'
    )
    refute d2.valid?
    expected_msg = "Pattern (..toomanyperiods) was not well formed for data_type body.\n"\
      "Nokogiri::CSS::SyntaxError: unexpected '.' after '.'"
    assert_equal [expected_msg], d2.errors.full_messages
  end
end
