require 'rails_helper'

RSpec.describe GithubProject, type: :model do

  describe "a new GithubProject" do
    it "it validates" do
      gh = GithubProject.new("https://www.github.com/ondrae/gitcollections")
      expect(gh).to be_valid
    end

    it "it requires github urls" do
      gh = GithubProject.new("https://www.google.com/ondrae/gitcollections")
      expect(gh).to_not be_valid
    end

    it "gets the right repo_path" do
      gh = GithubProject.new("https://www.github.com/ondrae/gitcollections")
      expect(gh.repo_path).to eq("ondrae/gitcollections")
    end
  end

end
