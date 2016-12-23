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

  describe "PUT #update_from_github" do

    it "gets new attributes from Github" do
      allow(GithubProject).to receive(:new).and_return(github_project)
      allow(github_project).to receive(:name).and_return("UPDATED NAME")
      allow(github_project).to receive(:description).and_return("UPDATED DESCRIPTION")

      put :update_from_github, {:id => project.to_param}

      project.reload
      expect(project.name).to eq("UPDATED NAME")
      expect(project.description).to eq("UPDATED DESCRIPTION")
    end
  end

  describe "GET #index" do
    it "assigns all projects as @projects" do
      project = Project.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe "GET #show" do
    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :show, {:id => project.to_param}, valid_session
      expect(assigns(:project)).to eq(project)
    end
  end

  describe "GET #new" do
    let(:user){create :user}
    let(:collection){create :collection, user: user}
    before do
      sign_in user
    end
    it "assigns a new project as @project" do
      get :new, {}, valid_session
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe "GET #edit" do
    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :edit, {:id => project.to_param}, valid_session
      expect(assigns(:project)).to eq(project)
    end
  end

  describe "POST #create" do
    context "an organization url" do
      let(:collection){ create :collection, id: 1 }
      let(:org_url_params) { { url: "https://github.com/TESTORG", collection_id: collection.id } }

      let(:gh_project){ double(GithubProject, name: "TEST NAME", description: "TEST DESCRIPTION", html_url: "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT" ) }
      let(:gh_org){ double(GithubOrganization, projects: [gh_project, gh_project]) }
      before do
        allow(GithubOrganization).to receive(:new).and_return( gh_org )
        allow_any_instance_of(Project).to receive(:update_issues)
      end

      it "creates two new Projects" do
        expect {
          post :create, {project: org_url_params }, valid_session
        }.to change(Project, :count).by(2)
      end

      it "redirects to parent collection" do
        post :create, { project: org_url_params }
        expect(response).to redirect_to collection_path(collection.name)
      end

    end

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
            post :create, {:project => valid_attributes}
          }.to change(Project, :count).by(1)
        end

        it "assigns a newly created project as @project" do
          post :create, {:project => valid_attributes}, valid_session
          expect(assigns(:project)).to be_a(Project)
          expect(assigns(:project)).to be_persisted
        end

        it "redirects to the created project" do
          post :create, {:project => valid_attributes}, valid_session
          expect(response).to redirect_to(collection_path(Project.last.collection_id))
        end

        it "updates the project from Github" do
          post :create, {:project => valid_attributes}, valid_session
          expect(Project.last.name).to eq("UPDATED NAME")
        end
      end

      # context "with invalid params" do
      #   it "assigns a newly created but unsaved project as @project" do
      #     post :create, {:project => invalid_attributes}, valid_session
      #     expect(assigns(:project)).to be_a_new(Project)
      #   end
      #
      #   it "re-renders the 'new' template" do
      #     post :create, {:project => invalid_attributes}, valid_session
      #     expect(response).to render_template("new")
      #   end
      # end

    end


  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested project" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => new_attributes}, valid_session
        project.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested project as @project" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => valid_attributes}, valid_session
        expect(assigns(:project)).to eq(project)
      end

      it "redirects to the project" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => valid_attributes}, valid_session
        expect(response).to redirect_to(project)
      end
    end

    context "with invalid params" do
      it "assigns the project as @project" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => invalid_attributes}, valid_session
        expect(assigns(:project)).to eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested project" do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, {:id => project.to_param}, valid_session
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      project = Project.create! valid_attributes
      delete :destroy, {:id => project.to_param}, valid_session
      expect(response).to redirect_to(projects_url)
    end
  end

end
