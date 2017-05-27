class Project < ActiveRecord::Base
  belongs_to :collection

  validates :url, presence: true, uniqueness: { scope: :collection, message: "can only add a project once per collection" }
  validates_format_of :url, with: /github\.com\/[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+\/?/, on: :create
  default_scope -> { order(:name) }

  def github_update
    github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"], auto_paginate: true)
    repo_name = url.split("github.com/")[1]
    response = github_api.repo repo_name
    self.name = response[:name]
    self.owner_login = response[:owner][:login]
    self.owner_avatar_url = response[:owner][:avatar_url]
    self.save
  end
end
