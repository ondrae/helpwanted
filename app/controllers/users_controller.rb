class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :update_from_github]

  def update_from_github
    @user.update_collections
    redirect_to @user
  end

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.friendly.find params[:id]
  end

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
