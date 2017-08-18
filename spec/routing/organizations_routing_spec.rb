require "rails_helper"

RSpec.describe OrganizationsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(:get => "collections/TEST/organizations/new").to route_to("organizations#new", collection_id: "TEST")
    end

    it "routes to #create" do
      expect(:post => "collections/TEST/organizations").to route_to("organizations#create", collection_id: "TEST")
    end

    it "routes to #destroy" do
      expect(:delete => "/organizations/1").to route_to("organizations#destroy", :id => "1")
    end
  end
end
