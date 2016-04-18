require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
    end
  end
end
