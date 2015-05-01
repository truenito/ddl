module UserPrivileges

  def can_create_games?
    self && !self.match_tokens.where(result: nil).any?
  end

  def playing?
    self && self.match_tokens.where(result: nil).any? && MatchToken.find(current_match_token_id).match.status == 'playing'
  end

  def in_match?(match_id)
    token = MatchToken.where(match_id: match_id, user_id: self.id)
    token.any?
  end

  def reported?(match_id)
    token = self.match_tokens.where(match_id: match_id, user_id: self.id).first
    token.reported?
  end

  # helpers

  def current_match_token_id
    self.match_tokens.where(result: nil).first.id
  end

end