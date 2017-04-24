require 'rails_helper'

RSpec.describe GithubProject, type: :model do
  let(:github_client) { double(Octokit::Client, repo: "ondrae/helpwanted", issues: [{title: "TITLE ONE"},{title: "TITLE TWO"}]) }
  before do
    allow(Octokit::Client).to receive(:new).and_return(github_client)
    @gh = GithubProject.new("https://www.github.com/ondrae/helpwanted")
    allow(@gh).to receive(:api_response).and_return({name: "UPDATED NAME", description: "UPDATED DESCRIPTION"})
  end

  describe "a new GithubProject" do
    it "it validates" do
      expect(@gh).to be_valid
    end

    it "it requires github urls" do
      @gh = GithubProject.new("https://www.google.com/ondrae/helpwanted")
      expect(@gh).to_not be_valid
      @gh = GithubProject.new("https://www.google.com")
      expect(@gh).to_not be_valid
    end

    it "gets the right repo_path" do
      expect(@gh.repo_path).to eq("ondrae/helpwanted")
    end

    it "gets the GithubProject name and description" do
      expect(@gh.name).to eq("UPDATED NAME")
      expect(@gh.description).to eq("UPDATED DESCRIPTION")
    end

    it "gets the projects issues" do
      expect(@gh.issues.count).to eq(2)
      expect(@gh.issues[0][:title]).to eq("TITLE ONE")
    end

    it "asks for only help wanted issues" do
      @gh.issues
      expect(github_client).to have_received(:issues).with("ondrae/helpwanted", { labels: "help wanted" })
    end
  end

end
