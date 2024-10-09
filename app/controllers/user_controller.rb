class UserController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render :new, :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:codename)
  end
end
