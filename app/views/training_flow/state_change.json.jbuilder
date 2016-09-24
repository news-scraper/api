json.state state
json.root_domain root_domain
json.training_logs do
  json.array! training_logs, partial: 'training_logs/training_log', as: :training_log
end
if @domain.present?
  json.domain do
    json.partial! "domains/domain", domain: @domain
  end
end
