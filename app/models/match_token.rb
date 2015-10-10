# MatchToken class, models the relation between a player (user) and a match,
# contains all the relevant - in between- information.
class MatchToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :match

  def reported?
    result.present?
  end
end
