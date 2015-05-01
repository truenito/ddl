class MatchToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :match

  def reported?
    self.result != nil
  end
end
