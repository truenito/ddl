require 'rails_helper'

describe MatchToken do
  let(:match_token) do
    MatchToken.new
  end

  it '#reported? should be false for a brand new Match Token' do
    expect(match_token.reported?).to eq(false)
  end
end
