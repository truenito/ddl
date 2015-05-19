require 'rails_helper'

describe User do
  let(:user) do
    User.new
  end

  it '#win_rate should be 0 for a new User' do
    expect(user.win_rate).to eq(0)
  end

  it '#to_label should be " - " for a new User' do
    expect(user.to_label).to eq(' - ')
  end

  it 'a new user shouldnt have admin privileges' do
    expect(user.admin?).to eq(false)
  end

  it '#facebook_authed? should be false for a new User' do
    expect(user.facebook_authed?).to eq(false)
  end

  it '#joinable? should be false for a new User' do
    expect(user.joinable?).to eq(false)
  end
end
