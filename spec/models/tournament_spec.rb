require 'rails_helper'

RSpec.describe Tournament, type: :model do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @completed_tournaments = FactoryGirl.create_list(:completed_tournament, 3)
    @uncompleted_tournaments = FactoryGirl.create_list(:inprogress_tournament, 3)
  end

  let(:tournament) { FactoryGirl.create(:tournament_with_participants) }

  it { expect(subject).to have_many(:rounds) }
  it { expect(subject).to have_many(:teams) }
  it { expect(subject).to have_many(:assessments) }
  it { expect(subject).to have_and_belong_to_many(:users) }

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

      expect { rank_users }.to change { tournament.users.pluck(:rank).sort }.from([nil] * 5).to([200, 400, 600, 800, 1000])
    end

    it 'should not change ranks if there is no assessments' do
      expect { rank_users }.not_to change { tournament.users.pluck(:rank) }
    end

    it 'should destroy all assessments of tournament' do
      create_assessments

      expect { rank_users }.to change { tournament.assessments.count }.from(5).to(0)
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

  context '#generate_teams' do
    let(:generate_teams) { tournament.generate_teams(1) }
    let(:top_players) { tournament.users.order(rank: :desc)[0..1] }

    let(:rank_players) do
      tournament.users.each.with_index { |u, i| u.update_attribute(:rank, i) }
    end

    it 'should accept team_size as argument' do
      expect { tournament.generate_teams }.to raise_error(ArgumentError, /expected 1/)
    end

    it 'should return Array' do
      expect(generate_teams).to be_kind_of(Array)
    end

    it 'should create teams of specified size' do
      expect(tournament.teams.count).to be_zero
      team_size = 3
      tournament.generate_teams(team_size)

      expect(tournament.teams.last.users.count).to eq(team_size)
    end

    it 'should generate div(participants.count / team_size) teams' do
      expect { tournament.generate_teams(2) }.to change { tournament.teams.count }.by(2)
      expect { generate_teams }.to change { tournament.teams.count }.by(5)
    end

    it 'should not generate teams if participants.count < team_size' do
      expect { tournament.generate_teams(tournament.users.count + 1) }.not_to change { tournament.teams.count }
    end

    it 'should separate top rated users in different teams' do
      rank_players
      top_players
      tournament.generate_teams(2)

      expect(tournament.teams.any? { |t| (t.users - top_players).empty? }).to be_falsey
    end

    it 'should return different result on each call' do
      rank_players
      expect(tournament.generate_teams(2)).not_to eq(tournament.generate_teams(2))
    end

    it 'should assign player to only one team' do
      teams_player_ids = tournament.generate_teams(2).flat_map { |t| t.users.pluck(:id) }

      expect(teams_player_ids.size).to eq(teams_player_ids.uniq.size)
    end
  end
end
