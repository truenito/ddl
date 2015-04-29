class HomeController < ActionController::Base
  layout 'home'

  def index
    @sidebar_stats = {
      most_wins: User.most_wins,
      most_captains: User.most_captains,
      most_creations: User.most_creations
    } if User.all.any?

    @stats = { match_count: Match.count,
      user_count: User.count,
      last_match: Match.last.created_at.strftime("%d/%m/%Y")
    } if Match.all.any?

    leaders = User.league_leaders if User.all.any?
    @leaders = UserDecorator.decorate_collection(leaders)
    latest_matches = Match.where("status = ? or status = ?", 'waiting', 'playing')
    @latest_matches = latest_matches.decorate
  end

  def live_matches
    latest_matches = Match.where("status = ? or status = ?", 'waiting', 'playing')
    @latest_matches = latest_matches.decorate

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  # def best_winrate
  #   soon
  #   User.all.map{|u| {u.win_rate => u.id}}
  # end

end
