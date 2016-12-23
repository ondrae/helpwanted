json.array!(@issues) do |issue|
  json.extract! issue, :id, :title, :url, :labels, :project_id, :github_updated_at
end
