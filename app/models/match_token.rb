class MatchToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :match
end
