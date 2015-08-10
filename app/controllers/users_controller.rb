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
    played_games = played_games.sort_by{ |x| x.created_at}.reverse
    @played_games = MatchDecorator.decorate_collection(played_games)
    @created_count = Match.where(creator_id: @user).count
  end

  def update
    @user = User.find params[:id]
    new_desc = params[:user][:description]
    respond_to do |format|
      if (@user.description = new_desc; @user.save!)
        format.html { redirect_to(@user, :notice => 'Sus cambios se realizaron con éxito!') }
        format.json { respond_with_bip(@user) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@user) }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:description, :id, :user)
  end

end
