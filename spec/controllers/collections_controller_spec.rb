require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  include Devise::TestHelpers

  describe "PUT #update_from_github" do
    let!(:collection) { create :collection }
    before do
      allow(Collection).to receive_message_chain(:friendly, :find).and_return(collection)
      allow(collection).to receive :update_projects
    end

    it "updates a collections projects" do
      put :update_from_github, {:id => collection.to_param}
      expect(assigns[:collection]).to eq collection
      expect(collection).to have_received :update_projects
    end
  end

  describe "GET #index" do
    let(:user) { create :user }
    let(:collection) { create :collection, user: user }
    let(:collection2) { create :collection, description: "BICYCLES" }
    before { sign_in user }

    it "shows all of a users collections" do
      get :index, params = { user_id: user.github_name }
      expect(assigns[:collections]).to include collection
      expect(assigns[:collections]).to_not include collection2
    end

    it "shows all the collections" do
      get :index
      expect(assigns[:collections]).to include collection, collection2
    end

    it "searching collections works" do
      get :index, params = { search: "BICYCLES" }
      expect(assigns[:collections]).to include collection2
      expect(assigns[:collections]).to_not include collection
    end
  end

  describe "GET #show" do
    let(:collection) { create :collection }
    let(:collection2) { create :collection }

    it "shows to collection" do
      get :show, {:id => collection.to_param}
      expect(assigns[:collection]).to eq collection
    end
  end

  describe "GET #new" do
    it "assigns a new collection as @collection" do
      get :new
      expect(assigns(:collection)).to be_a_new(Collection)
    end
  end

  describe "GET #edit" do
  end

  describe "POST #create" do
    context "with valid params" do
      let(:user) { create :user }
      let(:params) { { name: "TEST COLLECTION", description: "TEST DESCRIPTION", user: user } }
      it "creates a new Collection" do
        expect { post :create, { collection: params } }.to change(Collection, :count).by(1)
      end

      it "assigns a newly created collection as @collection" do
        post :create, { collection: params }
        expect(assigns(:collection)).to be_a(Collection)
        expect(assigns(:collection)).to be_persisted
      end

      it "redirects to the created collection" do
        post :create, { collection: params }
        expect(response).to redirect_to(Collection.last)
      end
    end

    context "with invalid params" do
      let(:user) { create :user }
      let(:params) { { name: nil, description: "TEST DESCRIPTION", user: user } }

      it "assigns a newly created but unsaved collection as @collection" do
        post :create, { collection: params }
        expect(assigns(:collection)).to be_a_new(Collection)
      end

      it "re-renders the 'new' template" do
        post :create, { collection: params }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:collection) { create :collection }
      let(:new_attributes) { { name: "UPDATED NAME", description: "UPDATED DESCRIPTION", slug: "updated-slug" } }

      it "updates the requested collection" do
        put :update, {id: collection.to_param, collection: new_attributes}
        collection.reload
        expect(collection.name).to eq("UPDATED NAME")
        expect(collection.description).to eq("UPDATED DESCRIPTION")
        expect(collection.slug).to eq("updated-slug")
      end
    end

    context "with invalid params" do
      let(:collection) { create :collection }
      let(:new_attributes) { { name: nil, description: "UPDATED DESCRIPTION", slug: "updated-slug" } }

      it "re-renders the 'edit' template" do
        put :update, {id: collection.to_param, collection: new_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:collection) { create :collection }

    it "destroys the requested collection" do
      expect {
        delete :destroy, {id: collection.to_param}
      }.to change(Collection, :count).by(-1)
    end

    it "redirects to the collections list" do
      delete :destroy, {id: collection.to_param}
      expect(response).to redirect_to(collections_url)
    end
  end

end
