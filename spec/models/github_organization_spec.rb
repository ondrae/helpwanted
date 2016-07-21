require 'rails_helper'

RSpec.describe GithubOrganization, type: :model do
  let(:gh_project){GithubProject.new("https://github.com/TEST_ORG/TEST_PROJECT")}
  before do
    @gh_org = GithubOrganization.new("https://www.github.com/TEST_ORG")
    allow(@gh_org).to receive(:projects).and_return([gh_project])
  end

  describe "a new GithubOrganization" do
    it "it validates" do
      expect(@gh_org).to be_valid
    end

    it "it requires github urls" do
      @gh_org = GithubOrganization.new("https://www.google.com/ondrae")
      expect(@gh_org).to_not be_valid
      @gh_org = GithubOrganization.new("https://www.google.com")
      expect(@gh_org).to_not be_valid
    end

    it "gets the right github org" do
      expect(@gh_org.org_name).to eq("TEST_ORG")
    end

    it "gets a list of projects" do
      expect(@gh_org.projects).to eq([gh_project])
    end
    #
    # it "gets the GithubProject name and description" do
    #   expect(@gh.name).to eq("UPDATED NAME")
    #   expect(@gh.description).to eq("UPDATED DESCRIPTION")
    # end
    #
    # it "gets the projects issues" do
    #   expect(@gh.issues.count).to eq(2)
    #   expect(@gh.issues[0][:title]).to eq("TITLE ONE")
    # end
  end

end
