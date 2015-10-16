# Support functions for Match testing.

def fill_match_with_users(match, user_count = 10)
  user_count.times do
    user = create(:authed_user)

    match_token = MatchToken.new(user_id: user.id, match_id: match.id)
    match_token.save!
  end
end

def create_and_save_match_token(user, match)
  match_token = MatchToken.new(user_id: user.id, match_id: match.id)
  match_token.save!
  match_token
end

def update_match_tokens(match, user_count = 6, result = 'radiant')
  match.users.take(user_count).each do |user|
    match_token = MatchToken.from_user_and_match(user.id, match.id)
    match_token.result = result
    match_token.save!
  end
end
