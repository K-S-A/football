require 'rails_helper'

RSpec.describe TournamentsController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/tournaments').to route_to('tournaments#index')
    end

    it 'doesn\'t route to #new' do
      expect(get: '/tournaments/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/tournaments/1').to route_to('tournaments#show', id: '1')
    end

    it 'doesn\'t route to #edit' do
      expect(get: '/tournaments/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/tournaments').to route_to('tournaments#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/tournaments/1').to route_to('tournaments#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/tournaments/1').to route_to('tournaments#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/tournaments/1').to route_to('tournaments#destroy', id: '1')
    end

    it 'routes to #destroy_teams' do
      expect(delete: '/tournaments/1/teams').to route_to('tournaments#destroy_teams', id: '1')
    end

    it 'routes to #index_teams' do
      expect(get: '/tournaments/1/teams').to route_to('tournaments#index_teams', id: '1')
    end
  end
end
