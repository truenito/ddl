# Team class, it's required to have two separate teams to play a match,
# a Team has the references of the players that belong to it.
class Team < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :match

  def self.create_for_match(balanced_teams_hash, match_id)
    captain_a = balanced_teams_hash[:radiant].sort_by(&:rating).reverse.first
    captain_b = balanced_teams_hash[:dire].sort_by(&:rating).reverse.first

    radiant = Team.new(match_id: match_id, captain_id: captain_a[:id], side: 'radiant')
    radiant.users << balanced_teams_hash[:radiant]; radiant.save!

    dire_team = Team.new(match_id: match_id, captain_id: captain_b[:id], side: 'dire')
    dire_team.users << balanced_teams_hash[:dire]; dire_team.save!
  end

  class << self
    # Interface to calculate Rating Change based on teams.
    def rating_change(radiant, dire)
      return nil if radiant.nil? || dire.nil?
      { radiant: team_rating_change(EloRating::Match.new, 'radiant', radiant, dire),
        dire: team_rating_change(EloRating::Match.new, 'dire', radiant, dire) }
    end

    # Calculates rating win/loss depending on the winner team, receives an
    # EloRating Match to calculate amounts with the update_ratings method.
    def team_rating_change(match, winner, radiant, dire)
      if winner == 'radiant'
        match.add_player(rating: radiant, winner: true)
        match.add_player(rating: dire)
        match.updated_ratings[0] - radiant
      else
        match.add_player(rating: radiant)
        match.add_player(rating: dire, winner: true)
        match.updated_ratings[1] - dire
      end
    end

    # Calculates team average rating.
    def rating_average(team, match)
      if match.ended?
        sum = 0; team.each { |u| sum += u['rating'].to_i }
      else
        sum = 0; team.users.each { |u| sum += u['rating'].to_i }
      end
      sum / 5
    end
  end
end
