require "rails_helper"

RSpec.describe IssuesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/issues").to route_to("issues#index")
    end

    it "routes to #show" do
      expect(:get => "/issues/1").not_to be_routable
    end

  end
end
