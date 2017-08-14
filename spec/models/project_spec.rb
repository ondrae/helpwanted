require 'rails_helper'

RSpec.describe Project, type: :model do

  let(:project) { create :project }

  describe "validations" do
    it "can only have one of the same projects per collection" do
      duplicate_project = Project.create(url: project.url, collection: project.collection)
      expect(duplicate_project).to_not be_valid

      project_new_url = Project.create(url: "https://github.com/differenturl/differenturl", collection: project.collection)
      expect(project_new_url).to be_valid
    end
  end

  describe "#delete" do
    before do
      3.times do
        create :issue, project: project
      end
    end
  end
end
