json.extract! domain, :id, :root_domain, :created_at, :updated_at
json.entries do
  json.array! domain.domain_entries, partial: 'domains/domain_entry', as: :domain_entry
end
