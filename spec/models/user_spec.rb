require 'rails_helper'

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
end
