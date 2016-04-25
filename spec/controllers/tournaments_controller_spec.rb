require 'rails_helper'

RSpec.describe TournamentsController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    Assessment.delete_all
    Team.delete_all
    Tournament.delete_all

    @tournament = FactoryGirl.create(:tournament)
    @tournaments = Tournament.all
    @valid_attrs = FactoryGirl.attributes_for(:tournament)
    @invalid_attrs = FactoryGirl.attributes_for(:invalid_tournament)
  end

  context 'GET #index' do
    let!(:call_action) { get :index }

    let(:result) do
      @tournaments.to_json(only: [:id, :name, :status, :sports_kind, :team_size],
                           include: [:users, :rounds])
    end

    include_examples 'for successfull request'
    include_examples 'for assigning instance variable', :tournaments
    include_examples 'for rendering templates', [:index, :_tournament]
    include_examples 'for responding with json', :array, :tournaments

    context 'when params[:status] is "completed"' do
      it 'assigns @tournaments with unrated tournaments' do
        tournament = FactoryGirl.create(:tournament, status: 'completed')
        FactoryGirl.create(:assessment, user: @admin, tournament: tournament)

        get :index, status: 'completed'
        expect(assigns(:tournaments)).to eq(@tournaments.reject{ |t| t.status != 'completed' })
      end
    end
  end

  context 'POST #create' do
    context 'with valid params' do
      let!(:call_action) { post :create, tournament: @valid_attrs }

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:create, :_tournament]

      it "assigns @tournament" do
        expect(assigns(:tournament).name).to eq(@valid_attrs[:name])
      end

      it 'responds with Hash of tournament attributes' do
        expect(response.body).to match(@valid_attrs[:name])
      end
    end

    context 'with invalid params' do
      let!(:call_action) { post :create, tournament: @invalid_attrs }

      include_examples 'for render nothing with status', 422

      it 'don\'t save the record to database' do
        expect(assigns(:tournament).persisted?).to be_falsey
      end
    end
  end
end
