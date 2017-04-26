require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  include Devise::TestHelpers

  let(:user) { create :user }
  let(:collection) { create :collection, user: user }
  let(:project) { create :project, collection: collection }
  let!(:issue) { create :issue, project: project }

  describe "#feature" do
    it "features the issues" do
      sign_in user
      put :feature, { id: issue.to_param }
      expect(issue.reload.featured).to be true
    end
  end

  describe "#unfeature" do
    it "unfeatures the issues" do
      sign_in user
      issue.update featured: true
      put :unfeature, { id: issue.to_param }
      expect(issue.reload.featured).to be false
    end
  end

end
