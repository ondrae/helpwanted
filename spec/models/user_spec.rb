require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = create :user
  end

  describe "#delete" do
    before do
      3.times do
        create :collection, user: @user
      end
    end

    it "deletes users's collections too" do
      expect(Collection.all.count).to eq(3)

      @user.destroy

      expect(Collection.all.count).to eq(0)
    end
  end

  describe "#update_collections" do
    issue_params = {
      title: "UPDATED TITLE",
      html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT/issues/1",
      labels: [{ name: "UPDATED LABEL ONE"},{ name: "UPDATED LABEL TWO" }]
    }
    let(:issues){ double(Issue, issue_params) }
    let(:gh_project){ double(GithubProject, name: "UPDATED NAME", description: "UPDATED DESCRIPTION", issues: [issues]) }
    before do
      allow(GithubProject).to receive(:new).and_return( gh_project )

      collection = create :collection, user: @user
      create :project, collection: collection
    end

    it "updates the user's collection's projects" do
      @user.update_collections

      expect(@user.projects.first.name).to eq "UPDATED NAME"
      expect(@user.projects.first.description).to eq "UPDATED DESCRIPTION"
    end
  end

end
