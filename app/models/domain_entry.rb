class DomainEntry < ApplicationRecord
  belongs_to :domain
  validates :domain, presence: true
end
