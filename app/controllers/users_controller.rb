class UsersController < ActionController::Base
  layout 'application'

  def index
    users = User.all.sort_by{|u| u.rating}.reverse
    @users = UserDecorator.decorate_collection(users)
  end

  def show
    user = User.find_by_name(params[:username])
    @user = user.decorate
    user_matches = user.matches
    played_games = user_matches.select{|x| x.status == 'ended'}
    @played_games = MatchDecorator.decorate_collection(played_games)
  end

end
