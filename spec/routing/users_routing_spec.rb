require 'rails_helper'

RSpec.describe 'routing to users', type: :routing do
  it 'routes /user/:username to user#show' do
    expect(:get => '/user/cerito').to route_to(
      controller: 'users',
      action: 'show',
      username: 'cerito'
    )
  end

  it 'does not expose a list of profiles' do
    expect(get: '/user').not_to be_routable
  end
end