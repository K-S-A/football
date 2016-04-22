require 'rails_helper'

RSpec.describe Tournament, type: :model do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @completed_tournaments = FactoryGirl.create_list(:completed_tournament, 3)
    @uncompleted_tournaments = FactoryGirl.create_list(:inprogress_tournament, 3)
  end

  it { expect(subject).to have_many(:rounds) }
  it { expect(subject).to have_many(:teams) }
  it { expect(subject).to have_many(:assessments) }
  it { expect(subject).to have_and_belong_to_many(:users) }

  context '#rated_by?' do
    subject { FactoryGirl.create(:tournament) }

    let(:create_assessment) { FactoryGirl.create(:assessment, user: @user, tournament: subject) }

    it 'should return true if there is assessments associated with user' do
      create_assessment

      expect(subject.rated_by?(@user.id)).to be_truthy
    end

    it 'should return false if there is no assessments associated with user' do
      expect(subject.rated_by?(@user.id)).to be_falsey
    end
  end

  context '#rank_users' do
    let(:tournament) { FactoryGirl.create(:tournament_with_participants) }
    let(:rank_users) { tournament.rank_users }

    let(:create_assessments) do
      tournament.users.each.with_index do |user, index|
        FactoryGirl.create(:assessment,
                           score: index,
                           rated_user_id: user.id,
                           tournament: tournament)
      end
    end

    it 'should change ranks of all tournament participants' do
      create_assessments

      expect{ rank_users }.to change{ tournament.users.pluck(:rank) }.from([nil]*5).to([1000, 800, 600, 400, 200])
    end

    it 'should not change ranks if there is no assessments' do
      expect{ rank_users }.not_to change{ tournament.users.pluck(:rank) }
    end

    it 'should destroy all assessments of tournament' do
      create_assessments

      expect{ rank_users }.to change{ tournament.assessments.count }.from(5).to(0)
    end
  end

  context '.unrated_tournaments' do
    subject { Tournament.unrated_tournaments(@user.id) }

    it 'should return Array' do
      expect(Tournament.unrated_tournaments(@user.id)).to be_kind_of(Array)
    end

    it 'should return tournaments with status "completed"' do
      expect(@completed_tournaments & subject).to eq(@completed_tournaments)
    end

    it 'should return tournaments that have no assessments by user' do
      rated_tournament = @completed_tournaments.first
      FactoryGirl.create(:assessment, user: @user, tournament: rated_tournament)
      FactoryGirl.create(:assessment, rated_user_id: @user.id, tournament: rated_tournament)

      expect(@completed_tournaments - subject).to eq([rated_tournament])
    end
  end
end
