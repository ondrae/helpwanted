class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :update_from_github]

  def update_from_github
    @user.update_collections
    redirect_to @user
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by_github_name params[:github_name]
    @collections = @user.collections
    @projects = @user.projects
    @issues = @user.issues
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end
end
