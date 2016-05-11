require 'rails_helper'

RSpec.describe RoundsController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create_list(:round, 3, tournament: @tournament)
    @rounds = @tournament.rounds
    @round = @rounds.first
    @round.teams << FactoryGirl.create(:team)
    @valid_attrs = FactoryGirl.build(:round).attributes
    @invalid_attrs = FactoryGirl.attributes_for(:invalid_round)
  end

  context 'GET #index' do
    let!(:call_action) { get :index, tournament_id: @tournament.id }

    include_examples 'for successfull request'
    include_examples 'for assigning instance variable', :rounds
    include_examples 'for rendering templates', [:index, :_round]

    it 'should match response schema "rounds"' do
      expect(response).to match_response_schema('rounds')
    end
  end

  context 'GET #show' do
    let!(:call_action) { get :show, tournament_id: @tournament.id, id: @round.id }

    include_examples 'for successfull request'
    include_examples 'for rendering templates', [:show]

    it 'assigns @round' do
      expect(assigns(:round)).to eq(@round)
    end

    it 'should match response schema "round"' do
      expect(response).to match_response_schema('round')
    end
  end

  context 'POST #create' do
    context 'with valid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, round: @valid_attrs }

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:_round]

      it 'assigns @tournament' do
        expect(assigns(:tournament).id).to eq(@tournament.id)
      end

      it 'assigns @round' do
        expect(assigns(:round).mode).to eq(@valid_attrs['mode'])
      end

      it 'should match response schema "round_create"' do
        expect(response).to match_response_schema('round_create')
      end
    end

    context 'with invalid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, round: @invalid_attrs }

      include_examples 'for render nothing with status', 422

      it 'don\'t save the record to database' do
        expect(assigns(:round)).to be_nil
      end
    end
  end

  context 'PATCH/PUT #update' do
    let(:round) { FactoryGirl.create(:round) }

    context 'with valid params' do
      let!(:call_action) do
        put :update, id: round.id, round: @valid_attrs
      end

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:show]

      it 'assigns updated project to @round' do
        expect(assigns(:round).mode).to eq(@valid_attrs['mode'])
      end

      it 'should match response schema "round"' do
        expect(response).to match_response_schema('round')
      end
    end

    context 'with invalid params' do
      let!(:call_action) do
        put :update, id: round.id, round: @invalid_attrs
      end

      include_examples 'for render nothing with status', 422

      it 'should not save changes to database' do
        expect(assigns(:round).changed?).to be_truthy
      end
    end
  end

  context 'DELETE #destroy' do
    context 'with existing tournament' do
      let(:round) { FactoryGirl.create(:round) }
      let!(:call_action) { delete :destroy, id: round.id }

      include_examples 'for successfull request', 'text/plain'
      include_examples 'for render nothing with status', 200

      it 'assigns @round' do
        expect(assigns(:round)).to eq(round)
      end
    end

    context 'with unexisting round' do
      let!(:call_action) { delete :destroy, id: Round.last.id.next }

      include_examples 'for render nothing with status', 404
    end
  end

  context 'DELETE #remove_team' do
    let!(:round) { FactoryGirl.create(:round_with_teams) }

    let(:remove_team) do
      delete :remove_team, id: round.id, team_id: round.teams.last.id
    end

    it 'should remove association to team' do
      expect { remove_team }.to change { round.teams.count }.by(-1)
    end

    it 'should not delete team itself' do
      expect { remove_team }.not_to change { Team.count }
    end
  end

  context 'GET #index_teams' do
    let!(:call_action) { get :index_teams, id: @round.id }

    include_examples 'for successfull request'
    include_examples 'for assigning instance variable', :round
    include_examples 'for rendering templates', [:'teams/index']

    it 'should assign @teams' do
      expect(assigns(:teams)).to eq(@round.teams)
    end

    it 'should match response schema "teams"' do
      expect(response).to match_response_schema('teams')
    end
  end
end
