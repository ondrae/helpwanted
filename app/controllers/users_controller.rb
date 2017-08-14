class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.friendly.find params[:id]
  end

  def destroy
    current_user.destroy
    redirect_to users_url
  end

end
