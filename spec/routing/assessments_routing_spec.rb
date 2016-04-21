require 'rails_helper'

RSpec.describe AssessmentsController, type: :routing do
  context 'routing' do
    it 'doesn\'t route to #index' do
      expect(get: '/tournaments/1/assessments').not_to be_routable
    end

    it 'doesn\'t route to #new' do
      expect(get: 'tournaments/1/assessments/new').not_to be_routable
    end

    it 'doesn\'t route to #show' do
      expect(get: '/assessments/1').not_to be_routable
    end

    it 'doesn\'t route to #edit' do
      expect(get: '/tournaments/1/assessments/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/tournaments/1/assessments').to route_to('assessments#create', tournament_id: '1')
    end

    it 'doesn\'t route to #update via PUT' do
      expect(put: '/assessments/1').not_to be_routable
    end

    it 'doesn\'t route to #update via PATCH' do
      expect(patch: '/assessments/1').not_to be_routable
    end

    it 'doesn\'t route to #destroy' do
      expect(delete: '/assessments/1').not_to be_routable
    end
  end
end
