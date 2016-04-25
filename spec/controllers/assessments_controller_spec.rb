require 'rails_helper'

RSpec.describe AssessmentsController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    Assessment.delete_all
    # Team.delete_all
    # Tournament.delete_all

    @tournament = FactoryGirl.create(:tournament)
    @valid_attrs = { rated_user_id: FactoryGirl.create(:user).id, score: 1 }
    @invalid_attrs = FactoryGirl.attributes_for(:invalid_assessment)
  end

  context 'POST #create' do
    context 'with valid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, assessments: [rated_user_id: @user.id] }
      let(:reset_action) { post :create, tournament_id: @tournament.id, assessments: [@valid_attrs] }

      include_examples 'for render nothing with status', 200

      it 'should save assessments to database' do
        expect { reset_action }.to change { Assessment.count }.by(1)
      end
    end

    context 'with invalid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, assessments: [@invalid_attrs] }

      include_examples 'for render nothing with status', 422
    end
  end
end
