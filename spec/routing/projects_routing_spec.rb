require "rails_helper"

RSpec.describe ProjectsController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "collections/TEST/projects/new").to route_to("projects#new", collection_id: "TEST")
    end

    it "routes to #create" do
      expect(:post => "collections/TEST/projects").to route_to("projects#create", collection_id: "TEST")
    end

    it "routes to #update via PUT" do
      expect(:put => "/projects/1").to route_to("projects#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/projects/1").to route_to("projects#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/projects/1").to route_to("projects#destroy", :id => "1")
    end

  end
end
