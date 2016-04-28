require 'rails_helper'

RSpec.describe TeamsController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/tournaments/1/teams').to route_to('teams#index', tournament_id: '1')
    end

    it 'doesn\'t route to #new' do
      expect(get: '/tournaments/1/teams/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/teams/2').to route_to('teams#show', id: '2')
    end

    it 'doesn\'t route to #edit' do
      expect(get: '/teams/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/tournaments/1/teams').to route_to('teams#create', tournament_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/teams/1').to route_to('teams#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/teams/1').to route_to('teams#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/teams/1').to route_to('teams#destroy', id: '1')
    end
  end
end
