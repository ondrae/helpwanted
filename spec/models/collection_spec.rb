require 'rails_helper'

RSpec.describe Collection, type: :model do

  before do
    @collection = create :collection
  end

  describe "#owner" do
    
  end

  describe "#update_projects" do
    issue_params = {
      title: "UPDATED TITLE",
      html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT/issues/1",
      labels: [{ name: "UPDATED LABEL ONE"},{ name: "UPDATED LABEL TWO" }]
    }
    let(:issues){ double(Issue, issue_params) }
    let(:gh_project){ double(GithubProject, name: "UPDATED NAME", description: "UPDATED DESCRIPTION", issues: [issues]) }
    before do
      allow(GithubProject).to receive(:new).and_return( gh_project )
      create :project, collection: @collection
    end
    it "updates the project" do
      @collection.update_projects

      expect(@collection.projects.first.name).to eq "UPDATED NAME"
      expect(@collection.projects.first.description).to eq "UPDATED DESCRIPTION"
    end
  end

  describe "#delete" do
    before do
      3.times do
        create :project, collection: @collection
      end
    end

    it "deletes collection's projects too" do
      expect(Project.all.count).to eq(3)

      @collection.destroy

      expect(Project.all.count).to eq(0)
    end
  end

  describe "#projects" do
    before do
      Timecop.travel(Time.now - 1.year) do
        create :project, collection: @collection
      end
      Timecop.travel(Time.now) do
        create :project, collection: @collection
      end
      Timecop.travel(Time.now - 1.day) do
        create :project, collection: @collection
      end

    end
    it "gets all of a collections projects" do
      expect(@collection.projects.count).to eq(3)
    end
    it "returns projects in order of updated_at" do
      expect(@collection.projects).to eq Project.order(updated_at: :desc)
    end
  end

  describe "#issues" do
    before do
      Timecop.travel(Time.now - 1.year) do
        create :project, collection: @collection
      end
      Timecop.travel(Time.now) do
        create :project, collection: @collection
      end
      Timecop.travel(Time.now - 1.day) do
        create :project, collection: @collection
      end
      Timecop.travel(Time.now - 1.year) do
        create :issue, project: Project.third
      end
      Timecop.travel(Time.now) do
        create :issue, project: Project.second
      end
      Timecop.travel(Time.now - 1.day) do
        create :issue, project: Project.first
      end
    end
    it "gets all of a collections issues" do
      expect(@collection.issues.count).to eq(3)
    end
    it "returns issues in order of updated_at" do
      expect(@collection.issues).to eq Issue.order(updated_at: :desc)
    end
  end

end
