require 'rails_helper'

RSpec.describe Collection, type: :model do

  before do
    @collection = create :collection
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
      3.times do
        create :project, collection: @collection
      end
    end
    it "gets all of a collections projects" do
      expect(@collection.projects.count).to eq(3)
    end
  end

  describe "#issues" do
    before do
      3.times do
        create :project, collection: @collection
      end
      3.times do |i|
        create :issue, project: Project.all[i]
      end
    end
    it "gets all of a collections issues" do
      expect(@collection.issues.count).to eq(3)
    end
  end

end
