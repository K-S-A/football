require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
      expect(get: '/tournaments/1/users').to route_to('users#index', tournament_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1').to route_to('users#show', id: '1')
    end
  end
end
