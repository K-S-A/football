require 'rails_helper'

RSpec.describe Tournament, type: :model do
  STATUSES = %w(not\ started completed in\ progress closed).freeze

  before(:all) { @user = FactoryGirl.create(:user) }

  let(:tournament) { FactoryGirl.create(:tournament_with_participants) }

  it { expect(subject).to have_many(:rounds).dependent(:destroy) }
  it { expect(subject).to have_many(:teams).dependent(:destroy) }
  it { expect(subject).to have_many(:assessments).dependent(:destroy) }
  it { expect(subject).to have_and_belong_to_many(:users) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_length_of(:name).is_at_least(3) }
  it { expect(subject).to validate_length_of(:name).is_at_most(254) }
  it { expect(tournament).to validate_uniqueness_of(:name).case_insensitive }

  it { expect(subject).to validate_presence_of(:status) }
  it { expect(subject).to validate_inclusion_of(:status).in_array(STATUSES) }

  it { expect(subject).to validate_presence_of(:sports_kind) }

  it { expect(subject).to validate_presence_of(:team_size) }
  it { expect(subject).to validate_inclusion_of(:team_size).in_range(1..20) }

  it 'should trigger removing teams on user association destroy' do
    tournament = FactoryGirl.create(:tournament_with_teams)
    tournament.teams.each { |team| team.users << @user }

    expect { tournament.users.delete(@user) }.to change { tournament.teams.count }.by(-5)
  end

  context '#rated_by?' do
    subject { FactoryGirl.create(:tournament) }

    let(:create_assessment) do
      FactoryGirl.create(:assessment, user: @user, tournament: subject)
    end

    it 'should return true if there is assessments associated with user' do
      create_assessment

      expect(subject.rated_by?(@user.id)).to be_truthy
    end

    it 'should return false if there is no assessments associated with user' do
      expect(subject.rated_by?(@user.id)).to be_falsey
    end
  end

  context '#rank_users' do
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

      expect { rank_users }.to change { tournament.users.pluck(:rank).sort }
        .from([nil] * 5)
        .to([200, 400, 600, 800, 1000])
    end

    it 'should not change ranks if there is no assessments' do
      expect { rank_users }.not_to change { tournament.users.pluck(:rank) }
    end

    it 'should destroy all assessments of tournament' do
      create_assessments

      expect { rank_users }.to change { tournament.assessments.count }
        .from(5)
        .to(0)
    end
  end

  context '#generate_teams' do
    let!(:tournament) { FactoryGirl.create(:tournament, team_size: 2) }

    let!(:add_participants) do
      tournament.users << FactoryGirl.create_list(:user, 5)
    end

    let(:generate_teams) { tournament.generate_teams }
    let(:top_players) { tournament.users.order(rank: :desc)[0..1] }

    let(:rank_players) do
      tournament.users.each.with_index { |u, i| u.update_attribute(:rank, i) }
    end

    it 'should not accept any arguments' do
      expect { tournament.generate_teams(1) }.to raise_error(ArgumentError, /expected 0/)
    end

    it 'should return Array' do
      expect(generate_teams).to be_kind_of(Array)
    end

    it 'should create teams of tournament team_size' do
      team_size = 4
      allow(tournament).to receive(:team_size).and_return(team_size)
      tournament.generate_teams

      expect(tournament.teams.last.users.count).to eq(team_size)
    end

    it 'should generate div(participants.count / team_size) teams' do
      allow(tournament).to receive(:team_size).and_return(2)
      expect { tournament.generate_teams }.to change { tournament.teams.count }.by(2)

      allow(tournament).to receive(:team_size).and_return(1)
      expect { tournament.generate_teams }.to change { tournament.teams.count }.by(5)
    end

    it 'should not generate teams if participants.count < team_size' do
      allow(tournament).to receive(:team_size).and_return(6)
      expect { tournament.generate_teams }.not_to change { tournament.teams.count }
    end

    it 'should separate top rated users in different teams' do
      rank_players
      tournament.generate_teams

      expect(tournament.teams.any? { |t| (t.users - top_players).empty? }).to be_falsey
    end

    # TODO: not fully covered edge cases.
    it 'should return different result on each call' do
      rank_players
      first_call = tournament.generate_teams
      tournament.teams.delete_all # prevents random uniq team name validation error
      second_call = tournament.generate_teams

      expect(first_call).not_to eq(second_call)
    end

    it 'should assign player to only one team' do
      teams_player_ids = tournament.generate_teams.flat_map { |t| t.users.pluck(:id) }

      expect(teams_player_ids.size).to eq(teams_player_ids.uniq.size)
    end
  end

  context '.unrated_by' do
    subject { described_class.unrated_by(@user) }
    before(:all) do
      @completed_tournament = FactoryGirl.create(:completed_tournament)
      @completed_tournament.users << @user
      FactoryGirl.create_list(:completed_tournament, 3)
      FactoryGirl.create_list(:inprogress_tournament, 3)
    end

    it 'should return Array' do
      expect(subject).to be_kind_of(Array)
    end

    it 'should return tournaments with status "completed"' do
      expect(subject).to eq([@completed_tournament])
    end

    it 'should return tournaments that have no assessments by user' do
      rated_tournament = FactoryGirl.create(:completed_tournament)
      rated_tournament.users << @user
      FactoryGirl.create(:assessment, rated_user_id: FactoryGirl.create(:user).id,
                                      user: @user,
                                      tournament: rated_tournament,
                                      score: 1)

      expect(subject).to eq([@completed_tournament])
    end
  end
end
