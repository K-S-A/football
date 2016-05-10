require 'rails_helper'

RSpec.describe RoundsController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/tournaments/1/rounds').to route_to('rounds#index', tournament_id: '1')
    end

    it 'doesn\'t route to #new' do
      expect(get: '/tournaments/1/rounds/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/tournaments/1/rounds/2').to route_to('rounds#show', tournament_id: '1', id: '2')
    end

    it 'doesn\'t route to #edit' do
      expect(get: '/rounds/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/tournaments/1/rounds').to route_to('rounds#create', tournament_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/rounds/1').to route_to('rounds#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/rounds/1').to route_to('rounds#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/rounds/1').to route_to('rounds#destroy', id: '1')
    end

    it 'routes to #remove_team' do
      expect(delete: '/rounds/1/teams/2').to route_to('rounds#remove_team', round_id: '1', id: '2')
    end

    it 'routes to #index_teams' do
      expect(get: '/rounds/1/teams').to route_to('rounds#index_teams', id: '1')
    end
  end
end
