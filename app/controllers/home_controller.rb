class HomeController < ActionController::Base
  layout 'home'

  before_action :sidebar_stats
  def index
    @stats = { match_count: Match.where(status: 'ended').count,
               user_count: User.count,
               last_match: Match.last.created_at.strftime('%d/%m/%Y')
              } if Match.all.any?

    leaders = User.league_leaders if User.all.any?
    @leaders = UserDecorator.decorate_collection(leaders)
    latest_matches = Match.live
    @latest_matches = latest_matches.decorate
  end

  def live_matches
    latest_matches = Match.live
    @latest_matches = latest_matches.decorate

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def sidebar_stats
    @sidebar_stats = {
      most_wins: User.most_wins,
      most_captains: User.most_captains,
      most_creations: User.most_creations
    } if User.all.any?
  end
end
