require 'uri'

class GithubProject
  include ActiveModel::Validations
  validates_format_of :url, :with => URI.regexp
  validates_format_of :url, :with => /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9]+\/?/

  attr_accessor :url

  def initialize(url)
    @url = url
    @github_api = Octokit::Client.new(:access_token => ENV["github_token"])
  end

  def get
     response = @github_api.repo "#{@project_owner}/#{@project_name}"
  end

end
