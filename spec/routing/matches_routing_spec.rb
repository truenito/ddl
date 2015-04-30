require 'rails_helper'

RSpec.describe 'routing to matches', :type => :routing do
  it 'routes /matches/1 to match#show' do
    expect(get: '/matches/1').to route_to(
      controller: 'matches',
      action: 'show',
      id: '1'
    )
  end

end