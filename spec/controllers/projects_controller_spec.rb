require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include Devise::TestHelpers

  let(:user)      { create :user }
  let(:collection){ create :collection, user: user }
  # let(:project)   { create :project, collection: collection, updated_at: Time.now }
  before do
    sign_in user
  end


  describe "GET #new" do
    let(:user){create :user}
    let(:collection){create :collection, user: user}
    before do
      sign_in user
    end
    it "assigns a new project as @project" do
      get :new, collection_id: collection.id
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, { project: { url: "https://github.com/TEST/REPO" }, collection_id: collection.id }
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, { project: { url: "https://github.com/TEST/REPO" }, collection_id: collection.id }
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create :user }
    let(:collection){ create :collection, user: user }
    let!(:project){ create :project, collection: collection }
    before do
      sign_in user
    end

    it "destroys the requested project" do
      expect {
        delete :destroy, { id: project.id }
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      delete :destroy, { id: project.id }
      expect(response).to redirect_to short_collection_path collection
    end
  end
end
