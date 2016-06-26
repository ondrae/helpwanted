require 'rails_helper'

RSpec.describe GithubProject, type: :model do
  before do
    @gh = GithubProject.new("https://www.github.com/ondrae/gitcollections")
    allow(@gh).to receive(:project).and_return({name: "UPDATED NAME", description: "UPDATED DESCRIPTION"})
    allow(@gh).to receive(:issues).and_return([{title: "TITLE ONE"},{title: "TITLE TWO"}])
  end

  describe "a new GithubProject" do
    it "it validates" do
      expect(@gh).to be_valid
    end

    it "it requires github urls" do
      @gh = GithubProject.new("https://www.google.com/ondrae/gitcollections")
      expect(@gh).to_not be_valid
      @gh = GithubProject.new("https://www.google.com")
      expect(@gh).to_not be_valid
    end

    it "gets the right repo_path" do
      expect(@gh.repo_path).to eq("ondrae/gitcollections")
    end

    it "gets the GithubProject name and description" do
      expect(@gh.name).to eq("UPDATED NAME")
      expect(@gh.description).to eq("UPDATED DESCRIPTION")
    end

    it "gets the projects issues" do
      expect(@gh.issues.count).to eq(2)
      expect(@gh.issues[0][:title]).to eq("TITLE ONE")
    end
  end

end
