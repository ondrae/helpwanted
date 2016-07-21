require 'uri'

class GithubOrganization
  include ActiveModel::Validations
  validates_format_of :url, :with => URI.regexp
  validates_format_of :url, :with => /github\.com\/[a-zA-Z\-_0-9]+/

  attr_accessor :url

  def initialize(url)
    @url = url
    @github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"], auto_paginate: true)
    /github\.com\/(?<org_name>[a-zA-Z\-_0-9]+)?/ =~ @url
    @org_name = org_name
  end

  def projects
    @projects ||= @github_api.org_repos @org_name
  end

  def org_name
    @org_name
  end

end
