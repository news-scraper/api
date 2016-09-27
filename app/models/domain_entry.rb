class DomainEntry < ApplicationRecord
  belongs_to :domain
  validates :domain, :data_type, presence: true
  validates :pattern,
    presence: {
      message: lambda  do |obj, _|
        "requires that a pattern be set for #{obj.data_type} when method is #{obj.method}"
      end
    },
    if: proc { |d| %w(xpath css).include?(d.method) }

  validate :valid_pattern

  def valid_pattern
    noko_html = Nokogiri::HTML("<html></html>")
    case method
    when 'xpath'
      noko_html.xpath("(#{pattern})[1]")
    when 'css'
      noko_html.css(pattern)
    end
  rescue => e
    msg = "(#{pattern}) was not well formed for data_type #{data_type}.\n"\
      "#{e.class}: #{e.message}"
    errors.add(:pattern, :invalid, message: msg)
  end

  def to_h
    { 'method' => method, 'pattern' => pattern }
  end
end
