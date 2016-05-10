require 'rails_helper'

RSpec.describe MatchesController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/rounds/1/matches').to route_to('matches#index', round_id: '1')
    end

    it 'doesn\'t route to #new' do
      expect(get: '/rounds/1/matches/new').not_to be_routable
    end

    it 'doesn\'t route to #show' do
      expect(get: '/matches/2').not_to be_routable
    end

    it 'doesn\'t route to #edit' do
      expect(get: '/matches/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/rounds/1/matches').to route_to('matches#create', round_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/rounds/2/matches/1').to route_to('matches#update', round_id: '2', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(put: '/rounds/2/matches/1').to route_to('matches#update', round_id: '2', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/matches/1').to route_to('matches#destroy', id: '1')
    end

    it 'routes to #generate' do
      expect(post: '/rounds/1/matches/generate').to route_to('matches#generate', round_id: '1')
    end
  end
end
