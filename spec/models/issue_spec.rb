require 'rails_helper'

RSpec.describe Issue, type: :model do

  describe "new issues" do
    it "validates" do
      issue = create :issue
      expect(issue).to be_valid
    end
  end

  it "has an issue number" do
    issue = create :issue
    expect(issue.number).to eq("1")
  end

end
