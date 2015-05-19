require 'rails_helper'

describe Match do
  let(:match) do
    Match.new
  end

  # Brand new matches
  # ##### ### #######
  it '#commit_match should be nil for a brand new match.' do
    expect(match.commit_match).to eq(nil)
  end

  it '#votes_number should be 0 for a brand new match.' do
    expect(match.votes_number).to eq(0)
  end

  it '#joinable? should be true for a brand new match.' do
    expect(match.joinable?).to eq(true)
  end

  it '#playing? should be false for a brand new match.' do
    expect(match.playing?).to eq(false)
  end

  it '#canceled? should be false for a brand new match.' do
    expect(match.canceled?).to eq(false)
  end

  it '#ended? should be false for a brand new match.' do
    expect(match.ended?).to eq(false)
  end

  it '#leavable? should be true for a brand new match.' do
    expect(match.leavable?).to eq(true)
  end

  it '#committable? should be false for a brand new match.' do
    expect(match.committable?).to eq(false)
  end
end
