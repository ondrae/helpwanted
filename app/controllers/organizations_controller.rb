class OrganizationsController < ApplicationController
  before_action :set_collection, except: :destroy
  before_action :owner_only, only: [:destroy]
  protect_from_forgery :except => [:create]

  # GET /organizations
  def index
    @organizations = @collection.organizations
  end

  # GET /organizations/new
  def new
    @title = "Add a organization"
    @organization = Organization.new
    @collection = Collection.friendly.find(params[:collection_id])
  end


  def create
    @organization = Organization.create(organization_params)
    if @organization.errors.empty?
      redirect_to short_collection_path @collection
    else
      render :new
    end
  end

  # DELETE /organizations/1
  def destroy
    organization = Organization.find(params[:id])
    organization.destroy
    redirect_to short_collection_path organization.collection
  end

  private

  def set_collection
    @collection = Collection.friendly.find(params[:collection_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    params.require(:organization).permit(:url, :collection_id)
  end

  def owner_only
    @organization = Organization.find(params[:id])
    render json: {}, status: :forbidden unless current_user == @organization.collection.user
  end
end
