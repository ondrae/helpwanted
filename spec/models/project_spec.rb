require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @project = create :project
  end

  describe "validations" do
    it "can only have one of the same projects per collection" do
      duplicate_project = Project.create(name: @project.name, url: @project.url, collection: @project.collection)
      expect(duplicate_project).to_not be_valid

      project_new_url = Project.create(name: @project.name, url: "https://github.com/differenturl", collection: @project.collection)
      expect(project_new_url).to be_valid
    end
  end

  describe "#gh_labels" do
  end

  describe "#update_project" do
    let(:gh_project){ double(GithubProject, name: "UPDATED NAME", description: "UPDATED DESCRIPTION") }
    before do
      allow(GithubProject).to receive(:new).and_return( gh_project )
    end

    it "updates the project" do
      @project.update_project

      expect(@project.name).to eq "UPDATED NAME"
      expect(@project.description).to eq "UPDATED DESCRIPTION"
    end
  end

  describe "#update_issues" do
    let(:mock_client) { Octokit::Client.new }
    let(:gh_project)  { create :github_project }

    let!(:issue) { create :issue, project: @project }
    # let(:label) { create :label }
    let(:mock_gh_issue)   { double(Object, title: "FAKE TITLE", html_url: "https://github.com/TESTORG/TESTPROJECT/issues/1", updated_at: Time.now, labels: [mock_gh_label, mock_gh_label, mock_gh_label]) }
    let(:mock_gh_label)   { double(Object, name: "FAKE LABEL", color: "#ffa500") }

    before do
      allow(GithubProject).to receive(:new).and_return( gh_project )
      allow(gh_project).to receive(:issues).and_return([mock_gh_issue])
    end

    it "updates the labels" do
      Delayed::Worker.delay_jobs = false

      expect(Delayed::Worker.logger).to receive(:debug).with("Updating issues of #{@project.url}")
      expect(Delayed::Worker.logger).to receive(:debug).with("Removing closed issue TEST TITLE from https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT")

      @project.update_issues
    end

    it "logs out when existing issues are closed" do
      Delayed::Worker.delay_jobs = false

      @project.update_issues

      expect(@project.reload.issues.first.labels.count).to eq 3
      expect(@project.issues.first.labels.first.name).to eq "FAKE LABEL"
    end

    it "starts a job to update the issues" do
      Delayed::Worker.delay_jobs = true

      expect { @project.update_issues }.to change { Delayed::Job.count }.by(1)
    end

    it "can take optional priorities" do
      Delayed::Worker.delay_jobs = true

      @project.delay(priority: 10).update_issues

      expect(Delayed::Job.last.priority).to eq 10
    end
  end

  describe "#delete" do
    before do
      3.times do
        create :issue, project: @project
      end
    end

    it "deletes project's issues too" do
      expect(Issue.all.count).to eq(3)

      @project.destroy

      expect(Issue.all.count).to eq(0)
    end
  end
end
