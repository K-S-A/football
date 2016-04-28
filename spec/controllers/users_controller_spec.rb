require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    @users = User.all
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:assessment, user: @admin, tournament: @tournament)
  end

  context 'GET #index' do
    let!(:call_action) { get :index }

    let(:result) do
      @users.to_json(only: [:id, :first_name, :last_name, :img_link, :rank, :admin])
    end

    include_examples 'for successfull request'
    include_examples 'for assigning instance variable', :users
    include_examples 'for rendering templates', [:index, :_user]
    include_examples 'for responding with json', :array, :users

    context 'when params[:tournament_id]' do
      it 'assigns @tournament' do
        tournament = FactoryGirl.create(:tournament)
        get :index, tournament_id: tournament.id

        expect(assigns(:tournament)).to eq(tournament)
      end

      context 'when tournament has assessments from user' do
        let!(:call_action) { get :index, tournament_id: @tournament.id, user_id: @admin.id }

        it 'responds with 400 status' do
          expect(response.status).to eq(400)
        end

        it 'renders nothing' do
          expect(response).to render_template(nil)
        end
      end
    end
  end
end
