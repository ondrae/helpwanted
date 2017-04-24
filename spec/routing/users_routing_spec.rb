require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do
    let(:user) { create :user, name: "TEST_GITHUB_NAME" }

    it "users/:github_name" do
      expect(get: "users/TEST_GITHUB_NAME").to route_to "users#show", id: "TEST_GITHUB_NAME"
    end

    it "users/:github_name/collections" do
      expect(get: "users/TEST_GITHUB_NAME/collections").to route_to "collections#index", user_id: "TEST_GITHUB_NAME"
    end

  end
end
