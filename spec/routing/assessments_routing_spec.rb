require 'rails_helper'

RSpec.describe AssessmentsController, type: :routing do
  context 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/assessments').to route_to('assessments#index', user_id: '1')
    end

    # it 'doesn\'t route to #new' do
    #   expect(get: '/assessments/new').not_to be_routable
    # end

    # it 'routes to #show' do
    #   expect(get: '/assessments/1').to route_to('assessments#show', id: '1')
    # end

    # it 'doesn\'t route to #edit' do
    #   expect(get: '/assessments/1/edit').not_to be_routable
    # end

    # it 'routes to #create' do
    #   expect(post: '/assessments').to route_to('assessments#create')
    # end

    # it 'routes to #update via PUT' do
    #   expect(put: '/assessments/1').to route_to('assessments#update', id: '1')
    # end

    # it 'routes to #update via PATCH' do
    #   expect(patch: '/assessments/1').to route_to('assessments#update', id: '1')
    # end

    # it 'routes to #destroy' do
    #   expect(delete: '/assessments/1').to route_to('assessments#destroy', id: '1')
    # end
  end
end
