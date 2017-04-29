require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  include Devise::TestHelpers

  describe "GET #index" do
    let(:user) { create :user }
    let(:collection) { create :collection, user: user }
    let(:collection2) { create :collection, name: "TESTING 1", description: "BICYCLES" }

    it "shows all of a users collections" do
      get :index, params = { user_id: user.github_name }
      expect(assigns[:collections]).to include collection
      expect(assigns[:collections]).to_not include collection2
    end

    it "shows all the collections" do
      get :index
      expect(assigns[:collections]).to include collection, collection2
    end
  end

  describe "GET #show" do
    let(:collection) { create :collection, name: "TESTING 1" }
    let(:collection2) { create :collection, name: "TESTING 2" }

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
    let(:collection) { create :collection }
    it "cant edit when not logged in" do
      get :edit, {id: collection.to_param}
      expect(response.status).to eq 403
    end
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
    let(:user) { create :user }
    let(:user2) { create :user }

    let(:collection) { create :collection, user: user }
    let(:new_attributes) { { name: "UPDATED NAME", description: "UPDATED DESCRIPTION", slug: "updated-slug" } }
    before { sign_in user }

    context "only collections owner can edit it" do
      it "when the owner is logged in, a collection can be updated" do
        put :update, {id: collection.to_param, collection: new_attributes}
        collection.reload
        expect(collection.name).to eq("UPDATED NAME")
        expect(collection.description).to eq("UPDATED DESCRIPTION")
        expect(collection.slug).to eq("updated-slug")
      end

      it "when trying to edit a non-owned collection" do
        sign_out user
        sign_in user2

        put :update, {id: collection.to_param, collection: new_attributes}
        expect(response.status).to eq 403
      end
    end

    context "with invalid params" do
      let(:new_attributes) { { name: nil, description: "UPDATED DESCRIPTION", slug: "updated-slug" } }

      it "re-renders the 'edit' template" do
        put :update, {id: collection.to_param, collection: new_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create :user }
    let!(:collection) { create :collection, user: user }
    before { sign_in user }

    it "destroys the requested collection" do
      expect {
        delete :destroy, {id: collection.to_param}
      }.to change(Collection, :count).by(-1)
    end

    it "redirects to the collections list" do
      delete :destroy, {id: collection.to_param}
      expect(response).to redirect_to(collections_url)
    end

    it "only destroys a users own collections" do
      sign_out user

      delete :destroy, {id: collection.to_param}
      expect(response.status).to eq 403
    end
  end

end
