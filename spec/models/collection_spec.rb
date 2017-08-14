require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:collection) { create :collection }

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
  end
end
