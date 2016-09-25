class DomainEntry < ApplicationRecord
  belongs_to :domain
  validates :domain, presence: true
  validates :pattern,
    presence: {
      message: lambda  do |obj, _|
        "requires that a pattern be set for #{obj.data_type} when method is #{obj.method}"
      end
    },
    if: proc { |d| %w(xpath css).include?(d.method) }
end
