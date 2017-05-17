require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:collection) { create :collection }

  describe "#github_update" do
    let(:gh_project){ double(GithubProject, name: "TEST NAME", description: "TEST DESCRIPTION", html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT", pushed_at: Time.current, owner_login: "TEST", owner_avatar_url: "TEST" ) }
    let(:project){ create :project, collection: collection}
    it "updates the project" do
      allow(GithubProject).to receive(:new).and_return( gh_project )
      allow(collection).to receive(:projects).and_return [project]
      expect(project).to receive(:github_update)

      collection.github_update
    end
  end

  describe "#delete" do
    before do
      3.times do
        create :project, collection: collection
      end
    end

    it "deletes collection's projects too" do
      expect(Project.all.count).to eq(3)

      collection.destroy

      expect(Project.all.count).to eq(0)
    end
  end

  describe "#projects" do
    before do
      3.times do
        create :project, collection: collection
      end
    end
    it "gets all of a collections projects" do
      expect(collection.projects.count).to eq(3)
    end
    it "returns projects in order of name" do
      expect(collection.projects).to eq Project.order(:name)
    end
  end

  describe "#issues" do
    before do
      project = create :project, collection: collection
      3.times do |i|
        create :issue, github_updated_at: Time.current - i.minute, project: project
      end
    end

    it "gets all of a collections issues" do
      expect(collection.issues.count).to eq(3)
    end
    it "returns issues in order of updated_at" do
      expect(collection.issues).to eq Issue.order(github_updated_at: :desc)
    end
  end
end
