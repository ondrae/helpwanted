require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:issue) { create :issue }
  let(:label) { create :label, issue: issue }

  describe "validations" do
    it "validates" do
      expect(issue).to be_valid
    end
  end

  describe "#issue" do
    it "has a parent issue" do
      expect(label.issue).to eq(issue)
    end
  end
end
