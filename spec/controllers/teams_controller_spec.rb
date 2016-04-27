require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    @tournament = FactoryGirl.create(:tournament_with_teams)
    @tournament.update_attribute(:team_size, 2)
    @valid_attrs = FactoryGirl.build(:team).attributes
    @invalid_attrs = FactoryGirl.build(:invalid_team).attributes
  end

  context 'GET #index' do
    let!(:call_action) { get :index, tournament_id: @tournament.id }

    include_examples 'for successfull request'
    include_examples 'for rendering templates', [:index, :_team]

    it 'assigns @teams' do
      expect(assigns(:teams).length).to eq(@tournament.teams.length)
    end

    it 'assigns @tournament' do
      expect(assigns(:tournament).id).to eq(@tournament.id)
    end

    it 'should match response schema "teams"' do
      expect(response).to match_response_schema('teams')
    end
  end

  context 'POST #create' do
    before(:all) do
      @tournment = FactoryGirl.create(:tournament)
    end

    context 'with valid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, team: @valid_attrs }

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:create, :_team]

      it 'assigns @team' do
        expect(assigns(:team).name).to eq(@valid_attrs['name'])
      end

      it 'should match response schema "team"' do
        expect(response).to match_response_schema('team')
      end
    end

    context 'with valid params and params[:team][:team_size]' do
      before(:all) do
        @tournament.users << FactoryGirl.create_list(:user, 5)
        @team = @valid_attrs.merge(team_size: 2)
      end

      let!(:call_action) { post :create, tournament_id: @tournament.id, team: @team }

      let(:call_again) do
        tournament = FactoryGirl.create(:tournament_with_participants)
        post :create, tournament_id: tournament.id, team: @team
      end

      it 'assigns @tournament' do
        expect(assigns(:tournament).id).to eq(@tournament.id)
      end

      it 'assigns @teams' do
        expect(assigns(:teams).count).to eq(2)
      end

      it 'should generate new teams' do
        expect { call_again }.to change { Team.count }.by(2)
      end

      it 'should match response schema "teams"' do
        expect(response).to match_response_schema('teams')
      end
    end

    context 'with invalid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, team: @invalid_attrs }

      include_examples 'for render nothing with status', 422

      it 'don\'t save the record to database' do
        expect(assigns(:team)).to be_nil
      end
    end
  end

  context 'DELETE #destroy' do
    context 'with existing team' do
      let!(:team) { FactoryGirl.create(:team) }
      let!(:call_action) { delete :destroy, id: team.id }

      include_examples 'for successfull request', 'text/plain'
      include_examples 'for render nothing with status', 200

      it 'assigns @team' do
        expect(assigns(:team)).to eq(team)
      end

      it 'should remove association to user if params[:user_id]' do
        team = FactoryGirl.create(:team_with_members)
        params = {id: team.id, user_id: team.users.last.id}

        expect{ delete :destroy, params }.to change { team.users.count }.by(-1)
      end
    end

    context 'with unexisting team' do
      let!(:call_action) { delete :destroy, id: Team.last.id.next }

      include_examples 'for render nothing with status', 404
    end
  end
end
