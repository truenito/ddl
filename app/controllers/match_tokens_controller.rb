class MatchTokensController < ActionController::Base
  layout 'application'
  before_filter :authenticate_user!

  def edit
    @match_token = MatchToken.find params[:id]
    match = Match.find @match_token.match_id

    if current_user.in_match? match.id
      @match = match.decorate
      set_match_entities @match
    else
      flash[:error] = 'Usted no está jugando esta partida.'
      redirect_to home_path
    end
  end

  def update
    @match_token = MatchToken.find params[:id]
    @match = @match_token.match

    respond_to do |format|
      if @match_token.update_attributes match_token_params
        @match.commit_match
        flash[:success] = 'Su voto fué procesado.'
        if @match.match_tokens.any?
          format.html { redirect_to edit_match_token_path @match_token }
        else
          format.html { redirect_to matches_path }
        end
      else
        flash[:error] = 'Este match no puede ser procesado.'
        format.html { render action: "edit" }
      end
    end
  end

  def set_match_entities(match)
    players = match.users
    @players = players.decorate
    @radiant_team = match.teams.first
    @dire_team = match.teams.last
    @radiant_radiant_teamvg = @radiant_team.users.sum(:rating) / 5
    @dire_radiant_teamvg = @dire_team.users.sum(:rating) / 5
  end

  private

  def match_token_params
    params.require(:match_token).permit(:result)
  end

end