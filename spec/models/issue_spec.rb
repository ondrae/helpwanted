require 'rails_helper'

RSpec.describe Issue, type: :model do

  let(:issue) { create :issue }

  describe "new issues" do
    it "validates" do
      expect(issue).to be_valid
    end
  end

  it "has an issue number" do
    expect(issue.number).to eq("1")
  end

end
