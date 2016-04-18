require 'rails_helper'

RSpec.describe MatchesController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/rounds/1/matches').to route_to('matches#index', round_id: '1')
    end

  #   it 'doesn\'t route to #new' do
  #     expect(get: 'tournament_id/1/matches/new').not_to be_routable
  #   end

  #   it 'routes to #show' do
  #     expect(get: '/matches/2').to route_to('matches#show', id: '2')
  #   end

  #   it 'doesn\'t route to #edit' do
  #     expect(get: '/matches/1/edit').not_to be_routable
  #   end

  #   it 'routes to #create' do
  #     expect(post: 'tournaments/1/matches').to route_to('matches#create', tournament_id: '1')
  #     expect(post: 'rounds/1/matches').to route_to('matches#create', round_id: '1')
  #   end

  #   it 'routes to #update via PUT' do
  #     expect(put: '/matches/1').to route_to('matches#update', id: '1')
  #   end

  #   it 'routes to #update via PATCH' do
  #     expect(patch: '/matches/1').to route_to('matches#update', id: '1')
  #   end

  #   it 'routes to #destroy' do
  #     expect(delete: '/matches/1').to route_to('matches#destroy', id: '1')
  #   end
  end
end
