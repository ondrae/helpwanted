json.array!(@collections) do |collection|
  json.extract! collection, :id, :name, :description, :github_updated_at
  json.url collection_url(collection, format: :json)
end
