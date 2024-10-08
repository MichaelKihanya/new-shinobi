class IndexController < ApplicationController
  def index
    @users = User.all
  end
end
