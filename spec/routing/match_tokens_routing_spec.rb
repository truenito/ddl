require 'rails_helper'

RSpec.describe 'routing to match tokens', :type => :routing do
  it "routes /match_tokens/1/edit to match_tokens#edit" do
    expect(get: '/match_tokens/1/edit').to route_to(
      controller: 'match_tokens',
      action: 'edit',
      id: '1'
    )
  end

end