require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  include Devise::TestHelpers

  let(:user)      { create :user }
  let(:collection){ create :collection, user: user }
  before do
    sign_in user
  end

  describe "GET #new" do
    it "assigns a new organization as @organization" do
      get :new, collection_id: collection.id
      expect(assigns(:organization)).to be_a_new(Organization)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Organization" do
        expect {
          post :create, { organization: { url: "https://github.com/TEST" }, collection_id: collection.id }
        }.to change(Organization, :count).by(1)
      end

      it "assigns a newly created organization as @organization" do
        post :create, { organization: { url: "https://github.com/TEST" }, collection_id: collection.id }
        expect(assigns(:organization)).to be_a(Organization)
        expect(assigns(:organization)).to be_persisted
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create :user }
    let(:collection){ create :collection, user: user }
    let!(:organization){ create :organization, collection: collection }
    before do
      sign_in user
    end

    it "destroys the requested organization" do
      expect {
        delete :destroy, { id: organization.id }
      }.to change(Organization, :count).by(-1)
    end

    it "redirects to the collection" do
      delete :destroy, { id: organization.id }
      expect(response).to redirect_to short_collection_path collection
    end
  end
end
