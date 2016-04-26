require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  include_context 'for logged-in user'

  before(:all) do
    @round = FactoryGirl.create(:round_with_teams)

    @round.teams.each_cons(2) do |t1, t2|
      @round.matches << FactoryGirl.create(:match, host_team: t1, guest_team: t2)
    end

    @valid_attrs = FactoryGirl.build(:match).attributes
    @invalid_attrs = FactoryGirl.build(:invalid_match).attributes
  end

  let(:round) { FactoryGirl.create(:round) }

  context 'GET #index' do
    let!(:call_action) { get :index, round_id: @round.id }

    include_examples 'for successfull request'
    include_examples 'for rendering templates', [:index, :_match]

    it 'assigns @round' do
      expect(assigns(:round)).to eq(@round)
    end

    it 'assigns @matches' do
      expect(assigns(:matches).count).to eq(@round.matches.count)
    end

    it 'should match response schema "matches"' do
      expect(response).to match_response_schema('matches')
    end
  end

  context 'POST #create' do
    context 'with valid params' do
      let!(:call_action) { post :create, round_id: round.id, match: @valid_attrs }

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:create, :_match]

      it 'assigns @match' do
        expect(assigns(:match).host_score).to eq(@valid_attrs['host_score'])
      end

      it 'should match response schema "match"' do
        expect(response).to match_response_schema('match')
      end
    end

    context 'with invalid params' do
      let!(:call_action) { post :create, round_id: round.id, match: @invalid_attrs }

      include_examples 'for render nothing with status', 422

      it 'don\'t save the record to database' do
        expect(assigns(:match)).to be_nil
      end
    end
  end

  context 'PATCH/PUT #update' do
    let(:round) { FactoryGirl.create(:round_with_matches) }

    context 'with valid params' do
      let!(:call_action) do
        put :update, round_id: round.id, id: round.matches.last.id, match: @valid_attrs
      end

      include_examples 'for successfull request'
      include_examples 'for rendering templates', [:create, :_team, :_match]

      it 'assigns updated match to @match' do
        expect(assigns(:match).host_score).to eq(@valid_attrs['host_score'])
        expect(assigns(:match).guest_score).to eq(@valid_attrs['guest_score'])
      end

      it 'should match response schema "match"' do
        expect(response).to match_response_schema('match')
      end
    end

    context 'with invalid params' do
      let!(:call_action) do
        put :update, round_id: round.id, id: round.matches.last.id, match: @invalid_attrs
      end

      include_examples 'for render nothing with status', 422

      it 'should not save changes to database' do
        expect(assigns(:match).changed?).to be_truthy
      end
    end
  end

  context 'DELETE #destroy' do
    context 'with existing match' do
      let!(:match) { FactoryGirl.create(:match) }
      let!(:call_action) { delete :destroy, id: match.id }

      include_examples 'for successfull request', 'text/plain'
      include_examples 'for render nothing with status', 200

      it "assigns @match" do
        expect(assigns(:match)).to eq(match)
      end
    end

    context 'with unexisting match' do
      let!(:call_action) { delete :destroy, id: Match.last.id.next }

      include_examples 'for render nothing with status', 404
    end
  end
end
