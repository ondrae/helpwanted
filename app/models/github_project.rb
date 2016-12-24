require 'uri'

class GithubProject
  include ActiveModel::Validations
  validates_format_of :url, :with => URI.regexp
  validates_format_of :url, :with => /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+\/?/

  attr_accessor :url, :name, :description, :issue

  def initialize(url)
    @url = url
    @github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"], auto_paginate: true)
    /github\.com\/(?<repo_path>[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+)\/?/ =~ @url
    @repo_path = repo_path
    puts "updating #{@repo_path} from github"
  end

  def api_response
    @api_response ||= @github_api.repo @repo_path
  end

  def repo_path
    @repo_path
  end

  def name
    api_response[:name]
  end

  def description
    api_response[:description]
  end

  def pushed_at
    if api_response[:pushed_at]
      api_response[:pushed_at]
    else
      api_response[:updated_at]
    end
  end

  def issues
    @issues ||= @github_api.issues @repo_path
  end

  def owner_login
    api_response[:owner][:login]
  end

  def owner_avatar_url
    api_response[:owner][:avatar_url]
  end
end
