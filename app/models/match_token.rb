# MatchToken class, models the relation between a player (user) and a match,
# contains all the relevant - in between- information.
class MatchToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :match

  def reported?
    result.present?
  end

  class << self
    def from_user_and_match user_id, match_id
      where(user_id: user_id, match_id: match_id).first
    end

    def created_recently(match, time_in_seconds = 5)
      match.match_tokens.select { |t| t.created_at > time_in_seconds.seconds.ago }.size
    end
  end
end
