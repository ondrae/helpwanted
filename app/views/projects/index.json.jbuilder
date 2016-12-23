json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :url, :collection_id, :github_updated_at
  json.url project_url(project, format: :json)
end
