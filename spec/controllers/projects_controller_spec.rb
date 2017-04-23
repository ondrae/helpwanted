require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include Devise::TestHelpers

  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: "TEST NAME",
      description: "TEST DESCRIPTION",
      url: "https://github.com/TESTPERSON/TESTPROJECT",
      collection_id: collection.id
    }
  }

  let(:invalid_attributes) {
    {
      url: nil
    }
  }

  let(:github_project) { double(GithubProject) }
  let(:user)      { create :user }
  let(:collection){ create :collection, user: user }
  let(:project)   { create :project, collection: collection, updated_at: Time.now }
  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all projects as @projects" do
      project = Project.create! valid_attributes
      get :index, collection_id: collection.id
      expect(assigns(:projects)).to eq([project])
    end
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
    context "a project url" do
      issue_params = {
        title: "UPDATED TITLE",
        html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT/issues/1",
        labels: [{ name: "UPDATED LABEL ONE"},{ name: "UPDATED LABEL TWO" }]
      }
      let(:issues){ double(Issue, issue_params) }
      let(:gh_project){ double(GithubProject, name: "UPDATED NAME", description: "UPDATED DESCRIPTION", issues: [issues]) }
      before do
        allow(GithubProject).to receive(:new).and_return( gh_project )
      end

      context "with valid params" do
        it "creates a new Project" do
          expect {
            post :create, { project: valid_attributes, collection_id: collection.id }
          }.to change(Project, :count).by(1)
        end

        it "assigns a newly created project as @project" do
          post :create, { project: valid_attributes, collection_id: collection.id }
          expect(assigns(:project)).to be_a(Project)
          expect(assigns(:project)).to be_persisted
        end

        it "redirects to the created project" do
          post :create, { project: valid_attributes, collection_id: collection.id }
          expect(response).to redirect_to short_collection_path(collection)
        end

        it "updates the project from Github" do
          allow(Project).to receive(:new).and_return(project)
          allow(project).to receive :update_project
          allow(project).to receive :update_issues

          post :create, { project: valid_attributes, collection_id: collection.id }

          expect(project).to have_received :update_project
          expect(project).to have_received :update_issues
        end
      end
    end

    context "an organization url" do
      let(:collection){ create :collection, id: 1 }
      let(:org_url_params) { { url: "https://github.com/TESTORG", collection_id: collection.id } }

      let(:gh_project){ double(GithubProject, name: "TEST NAME", description: "TEST DESCRIPTION", html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT" ) }
      let(:gh_project2){ double(GithubProject, name: "TEST NAME", description: "TEST DESCRIPTION", html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT2" ) }
      let(:gh_org){ double(GithubOrganization, projects: [gh_project, gh_project2]) }
      before do
        allow(GithubOrganization).to receive(:new).and_return( gh_org )
        allow_any_instance_of(Project).to receive(:update_issues)
      end

      it "creates two new Projects" do
        expect {
          post :create, { project: org_url_params, collection_id: collection.id }
        }.to change(Organization, :count).by(1)
      end

      it "redirects to parent collection" do
        post :create, { project: org_url_params, collection_id: collection.id }
        expect(response).to redirect_to short_collection_path(collection)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:collection){ create :collection, id: 1 }

    it "destroys the requested project" do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, { id: project.to_param, collection_id: collection.id }
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      project = Project.create! valid_attributes
      delete :destroy, { id: project.to_param, collection_id: collection.id }
      expect(response).to redirect_to short_collection_path collection
    end
  end
end
