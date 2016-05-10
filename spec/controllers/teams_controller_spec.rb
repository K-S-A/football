require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    @tournament = FactoryGirl.create(:tournament_with_teams)
    @tournament.update_attribute(:team_size, 2)
    @valid_attrs = FactoryGirl.build(:team).attributes
    @invalid_attrs = FactoryGirl.build(:invalid_team).attributes
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

    context 'with invalid params' do
      let!(:call_action) { post :create, tournament_id: @tournament.id, team: @invalid_attrs }

      include_examples 'for render nothing with status', 422

      it 'don\'t save the record to database' do
        expect(assigns(:team)).to be_nil
      end
    end
  end

  context 'POST #generate' do
    context 'with params[:team][:team_size]' do
      before(:all) do
        @tournament.users << FactoryGirl.create_list(:user, 5)
        @team = @valid_attrs.merge(team_size: 2)
      end

      let!(:call_action) do
        post :generate, tournament_id: @tournament.id, team: @team
      end

      let(:call_again) do
        post :generate, tournament_id: @tournament.id, team: @team
      end

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:index, :_team]

      it 'assigns @tournament' do
        expect(assigns(:tournament).id).to eq(@tournament.id)
      end

      it 'assigns @teams' do
        expect(assigns(:teams).count).to eq(2)
      end

      it 'should generate new teams' do
        @tournament.teams.order(:id).offset(5).destroy_all

        expect { call_again }.to change { Team.count }.by(2)
      end

      it 'should match response schema "teams"' do
        expect(response).to match_response_schema('teams')
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

      it 'should remove team' do
        team = FactoryGirl.create(:team)

        expect { delete :destroy, id: team.id }.to change { Team.count }.by(-1)
      end
    end

    context 'with unexisting team' do
      let!(:call_action) { delete :destroy, id: Team.last.id.next }

      include_examples 'for render nothing with status', 404
    end
  end


  context 'DELETE #remove_user' do
    context 'with existing team' do
      let!(:team) { FactoryGirl.create(:team_with_members) }
      let!(:call_action) { delete :remove_user,
                                  id: team.id,
                                  user_id: team.users.last.id }
      let(:params) { { id: team.id, user_id: team.users.last.id } }

      include_examples 'for successfull request', 'text/plain'
      include_examples 'for render nothing with status', 200

      it 'assigns @team' do
        expect(assigns(:team)).to eq(team)
      end

      it 'should remove association to user' do
        expect { delete :remove_user, params }.to change { team.users.count }.by(-1)
      end

      it 'should not remove user record' do
        expect { delete :remove_user, params }.not_to change { User.count }
      end
    end

    context 'with unexisting team' do
      let!(:call_action) { delete :remove_user,
                                  id: Team.last.id.next,
                                  user_id: 1 }

      include_examples 'for render nothing with status', 404
    end
  end
end
