require 'rails_helper'

RSpec.describe Issue, type: :model do

  describe "new issues" do
    it "validates" do
      issue = create :issue
      expect(issue).to be_valid
    end
  end

end
