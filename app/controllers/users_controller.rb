class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_url
    else
      render :index, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:codename)
  end

end
