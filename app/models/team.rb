class Team < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :match

  def self.create_for_match(balanced_teams_hash, match_id)
    captain_a = balanced_teams_hash[:radiant_team].sort_by(&:rating).reverse.first
    captain_b = balanced_teams_hash[:dire_team].sort_by(&:rating).reverse.first

    radiant_team = Team.new(match_id: match_id, captain_id: captain_a[:id], side: 'radiant')
    radiant_team.users << balanced_teams_hash[:radiant_team]
    radiant_team.save!

    dire_team = Team.new(match_id: match_id, captain_id: captain_b[:id], side: 'dire')
    dire_team.users << balanced_teams_hash[:dire_team]
    dire_team.save!

  end

  def self.rating_change(radiant, dire)
    if radiant == nil || dire == nil
      return nil
    else
      match = nil
      match = EloRating::Match.new
      match.add_player(rating: radiant, winner: true)
      match.add_player(rating: dire)
      change_a = match.updated_ratings
      change_a = change_a[0] - radiant

      match = EloRating::Match.new
      match.add_player(rating: radiant)
      match.add_player(rating: dire, winner: true)
      change_b = match.updated_ratings
      change_b = change_b[1] - dire

      {radiant: change_b, dire: change_a}
    end
  end
end
