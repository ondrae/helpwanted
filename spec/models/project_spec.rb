require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @project = create :project
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
    it "starts a job to update the issues" do
      expect { @project.update_issues }.to change { Delayed::Job.count }.by(1)
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
