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
end
