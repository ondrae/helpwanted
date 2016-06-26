json.array!(@issues) do |issue|
  json.extract! issue, :id, :title, :url, :labels, :project_id
  json.url issue_url(issue, format: :json)
end
