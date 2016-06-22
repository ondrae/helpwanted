json.array!(@issues) do |issue|
  json.extract! issue, :id, :title, :url, :body, :labels, :project_id
  json.url issue_url(issue, format: :json)
end
