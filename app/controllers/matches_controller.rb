class MatchesController < ActionController::Base
  layout 'application'
  before_filter :authenticate_user!, :except => [:show, :index, :match_info]

def index
    matches = Match.all
    @matches = matches.decorate.sort_by{ |m| m.created_at}.reverse

    respond_to do |format|
      format.html
      format.json { render json: @matches }
    end
  end

  def show
    match = Match.find(params[:id])
    @match = match.decorate
    set_match_entities(@match)

    @match_token = MatchToken.where(user_id: current_user, match_id: params[:id]).first if current_user && current_user.in_match?(@match.id)
    (@rating_change = Team.rating_change(@radiant_team_avg, @dire_team_avg)) if @match.teams.any?

    respond_to do |format|
      format.html
      format.json { render json: @match }
    end
  end

  def match_info
    match = Match.find(params[:id])
    @match = match.decorate
    set_match_entities(match)
    @new_players_count = @match.match_tokens.select{|t| t.created_at > 5.seconds.ago}.size

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def new
    @match = Match.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @match = Match.find(params[:id])
    if current_user && current_user.match_tokens.exists?(match_id: @match.id)
      @players = @match.users
      @radiant_team = @match.teams.first
      @dire_team = @match.teams.last
    else
      redirect_to root_path
    end
  end

  def create
    @match = Match.new(match_params)
    @match.creator_id = current_user.id

    respond_to do |format|
      if @match.save
        flash[:success] = 'La partida se creó correctamente.'
        redirect_to @match
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        flash[:success] =  'La partida se guardó correctamente.'
        redirect_to @match
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.match_tokens.destroy_all
    @match.status = 'canceled'
    @match.save

    respond_to do |format|
      format.html { redirect_to matches_url }
    end
  end

  def leave
    match = Match.find(params[:id])
    if match.leavable?
      if current_user && current_user.match_tokens.exists?(match_id: match.id)
        current_user.leave_match(match)
        flash[:success] =  'Usted salió de la partida.'
      else
        flash[:error] = 'Usted no puede salir de esta partida, no está registrado en ella.'
      end
    else
      flash[:error] = 'La partida se está jugando, usted no puede salir de ella.'
    end
    redirect_to match_path(match)
  end

  def join
    @match = Match.find(params[:id])

    if @match.joinable? && current_user.joinable?
      match_token = MatchToken.new(user_id: current_user.id, match_id: params[:id])
    end

    redirect_to user_omniauth_authorize_path(:facebook) unless current_user.joinable?
    if current_user.joinable? && !current_user.in_match?(@match.id)
      match_token.save!
      flash[:success] =  'Usted entró a la partida!'
      if @match.match_tokens.count == 10
        @match.create_teams
        @match.status = 'playing'
        @match.save!
        flash[:success] =  'La partida comenzó!'
      end
      redirect_to match_path(@match)
    end
  end

  def set_match_entities(match)
    players = match.users.order("match_tokens.created_at ASC")
    @players = players.decorate
    @creator = User.find(@match.creator_id)
    @radiant_team = match.teams.first
    @dire_team = match.teams.last

    if @radiant_team.present?
      @radiant_team_avg = (@radiant_team.users.sum(:rating) / @radiant_team.users.count)
      @dire_team_avg = (@dire_team.users.sum(:rating) / @dire_team.users.count)
    end
  end

  private

  def match_params
    params.require(:match).permit(:name, :password)
  end

end

