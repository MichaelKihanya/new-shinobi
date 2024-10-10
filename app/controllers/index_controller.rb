class IndexController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    
  end

end
