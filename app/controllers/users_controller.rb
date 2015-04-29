class UsersController < ActionController::Base
  layout 'application'

  def index
    users = User.all.sort_by{|u| u.rating}.reverse
    @users = UserDecorator.decorate_collection(users)
  end

  def show
    user = User.find_by_name(params[:username])
    @user = user.decorate
  end

end
