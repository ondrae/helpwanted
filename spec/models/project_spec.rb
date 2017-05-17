require 'rails_helper'

RSpec.describe Project, type: :model do

  let(:project) { create :project }
  let(:gh_project)  { create :github_project }

  before { Delayed::Worker.delay_jobs = false }

  describe "validations" do
    it "can only have one of the same projects per collection" do
      duplicate_project = Project.create(name: project.name, url: project.url, collection: project.collection)
      expect(duplicate_project).to_not be_valid

      project_new_url = Project.create(name: project.name, url: "https://github.com/differenturl/differenturl", collection: project.collection)
      expect(project_new_url).to be_valid
    end
  end

  describe "#github_update" do
    let(:gh_project){ double(GithubProject, name: "UPDATED NAME", description: "UPDATED DESCRIPTION", pushed_at: Time.current, owner_login: "TEST", owner_avatar_url: "TEST", issues: []) }
    let(:issue) { create :issue, project: project }
    let(:mock_gh_issue)   { double(Object, title: "FAKE TITLE", html_url: "https://github.com/TESTORG/TESTPROJECT/issues/1", updated_at: Time.now, labels: [mock_gh_label, mock_gh_label, mock_gh_label]) }
    let(:mock_gh_label)   { double(Object, name: "FAKE LABEL", color: "#ffa500") }

    before do
      allow(GithubProject).to receive(:new).and_return( gh_project )
      allow(gh_project).to receive(:issues).and_return([mock_gh_issue])
    end

    it "updates the project" do
      project.github_update

      expect(project.name).to eq "UPDATED NAME"
      expect(project.description).to eq "UPDATED DESCRIPTION"
    end

    it "finds new issues" do
      expect{ project.github_update }.to change{Issue.count}.by 1
    end

    it "updates labels" do
      project.github_update

      expect(project.reload.issues.first.labels.count).to eq 3
      expect(project.issues.first.labels.first.name).to eq "FAKE LABEL"
    end

    it "starts a job to update the issues" do
      Delayed::Worker.delay_jobs = true

      expect { project.github_update }.to change { Delayed::Job.count }.by(1)
    end

    it "can take optional priorities" do
      Delayed::Worker.delay_jobs = true

      project.delay(priority: 10).github_update

      expect(Delayed::Job.last.priority).to eq 10
    end
  end

  describe "#delete" do
    before do
      3.times do
        create :issue, project: project
      end
    end

    it "deletes project's issues too" do
      expect(Issue.all.count).to eq(3)

      project.destroy

      expect(Issue.all.count).to eq(0)
    end
  end
end
