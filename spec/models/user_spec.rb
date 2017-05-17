require 'rails_helper'
include ActiveJob::TestHelper


RSpec.describe User, type: :model do
  let(:user) { create :user }
  before do
    3.times do
      create :collection, user: user
    end
  end

  describe "#delete" do
    it "deletes users's collections too" do
      expect(Collection.all.count).to eq(3)

      user.destroy

      expect(Collection.all.count).to eq(0)
    end
  end

  describe "#github_update" do
    let(:collection) { double(Collection) }
    it "updates the user's collection's projects" do
      allow(user).to receive(:collections).and_return([collection])
      expect(collection).to receive(:github_update)
      user.github_update
    end
  end

end
