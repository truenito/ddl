require 'rails_helper'
require 'support/match_support'

# TODO: @truenito some tests are chunky, simplify methods to simplify them.
describe Match do
  # Match statuses
  it 'should be joinable if its new.' do
    match = build(:match)
    expect(match.joinable?).to eq(true)
  end

  it 'shouldnt be joinable if its being played.' do
    live_match = build(:live_match)
    expect(live_match.joinable?).to eq(false)
  end

  it 'shouldnt be being played if its new.' do
    match = build(:match)
    expect(match.playing?).to eq(false)
  end

  it 'should be being played if its live.' do
    live_match = build(:live_match)
    expect(live_match.playing?).to eq(true)
  end

  it 'shouldnt be canceled if its new.' do
    match = build(:match)
    expect(match.canceled?).to eq(false)
  end

  it 'shouldnt have ended if its new.' do
    match = build(:match)
    expect(match.ended?).to eq(false)
  end

  it 'shouldnt have ended if its being played.' do
    live_match = build(:live_match)
    expect(live_match.ended?).to eq(false)
  end

  it 'should be leavable if its new.' do
    match = build(:match)
    expect(match.leavable?).to eq(true)
  end

  it 'shouldnt be leavable if its live.' do
    live_match = build(:live_match)
    expect(live_match.leavable?).to eq(false)
  end

  # Match helpers.
  it 'shouldnt have any votes if its new.' do
    match = build(:match)
    expect(match.votes_number).to eq(0)
  end

  # Canceling a match.
  it '#cancel should cancel a new match.' do
    match = build(:match)
    match.cancel
    expect(match.status).to eq('canceled')
    expect(match.winner_team).to eq(nil)
  end

  it '#cancel shouldnt cancel a live match.' do
    live_match = build(:live_match)

    live_match.cancel
    expect(live_match.status).to_not eq('canceled')
    expect(live_match.winner_team).to eq(nil)
  end

  # Joining a match.
  it 'should let a facebook authed, not currently playing user join a #joinable? match.' do
    match = build(:match)
    user = build(:authed_user)
    expect(user.joinable?).to eq(true)
    expect(user.unjoinable? || user.in_match?(match.id)).to eq(false)
    expect(match.joinable? && user.joinable?).to eq(true)

    match_token = create_and_save_match_token(user, match)
    expect(match.match_tokens).to eq([match_token])
  end

  it 'shouldnt let a non facebook authed, not currently playing user join a #joinable? match.' do
    match = build(:match)
    user = build(:non_authed_user)
    expect(user.joinable?).to eq(false)
    expect(user.unjoinable? || user.in_match?(match.id)).to eq(false)
    expect(match.joinable? && user.joinable?).to eq(false)
  end

  it 'shouldnt let a facebook authed, currently playing user join a #joinable? match.' do
    user = build(:authed_user)
    live_match = build(:live_match)
    expect(user.joinable?).to eq(true)
    expect(user.unjoinable? || user.in_match?(live_match.id)).to eq(false)
    expect(live_match.joinable? && user.joinable?).to eq(false)
  end

  it 'shouldnt let a non facebook authed, currently playing user join a #joinable? match.' do
    user = build(:non_authed_user)
    live_match = build(:live_match)
    expect(user.joinable?).to eq(false)
    expect(user.unjoinable? || user.in_match?(live_match.id)).to eq(false)
    expect(live_match.joinable? && user.joinable?).to eq(false)
  end

  it 'should let a user leave a match that is not being played.' do
    match = build(:match)
    user = build(:authed_user)

    match_token = create_and_save_match_token(user, match)

    user.leave_match(match)
    expect(match.match_tokens).to_not eq([match_token])
  end

  it 'shouldnt let a user leave a match that is being played.' do
    live_match = build(:live_match)
    user = build(:authed_user)

    match_token = create_and_save_match_token(user, live_match)

    user.leave_match(live_match)
    expect(live_match.match_tokens).to eq([match_token])
  end

  it 'should start a match with enough players in the pool.' do
    match = create(:match)
    fill_match_with_users(match, 10)

    match.start
    expect(match.status).to eq('playing')
  end

  it 'shouldnt start a match without enough players in the pool.' do
    match = create(:match)
    fill_match_with_users(match, 9)

    match.start
    expect(match.status).to eq('waiting')
  end

  it 'should balance teams correctly, rating difference must be minimal.' do
    match = create(:match)
    fill_match_with_users(match, 10)

    match.start
    expect((Team.rating_average(match.teams.first, match)) - (Team.rating_average(match.teams.last, match)).abs).to be <= 6
  end

  it 'should end a match and assign winner team correctly.' do
    match = create(:match)
    fill_match_with_users(match, 10)
    match.start
    update_match_tokens(match, 6)
    match.commit

    expect(match.status).to eq('ended')
    expect(match.winner_team).to eq(false)
  end

  # TODO: @truenito when update_player_stats gets changed remember to simplify this and
  # make it more accurate.
  it 'should substract losing player rating.' do
    match = create(:match)
    fill_match_with_users(match, 10)
    match.start

    losing_user_old_rating = match.teams.last.users.first.rating
    update_match_tokens(match, 6)
    match.commit
    losing_user_new_rating = match.teams.last.users.first.rating

    expect(losing_user_new_rating).to be < losing_user_old_rating
  end

  # TODO: @truenito when update_player_stats gets changed remember to simplify this and
  # make it more accurate.
  it 'should increase winning player rating.' do
    match = create(:match)
    fill_match_with_users(match, 10)
    match.start

    winning_user_old_rating = match.teams.first.users.first.rating
    update_match_tokens(match, 6)
    match.commit
    winning_user_new_rating = match.teams.first.users.first.rating

    expect(winning_user_new_rating).to be > winning_user_old_rating
  end
end
