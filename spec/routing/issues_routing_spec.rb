require "rails_helper"

RSpec.describe IssuesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "collections/TEST-COLLECTION/issues").to route_to("issues#index", collection_id: "TEST-COLLECTION")
    end

  end
end
