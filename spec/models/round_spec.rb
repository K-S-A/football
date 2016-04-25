require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:round) { FactoryGirl.create(:round_with_teams, teams_count: 3) }

  it { expect(subject).to belong_to(:tournament) }
  it { expect(subject).to have_many(:matches).dependent(:destroy) }
  it { expect(subject).to have_and_belong_to_many(:teams) }

  it { expect(subject).to validate_presence_of(:mode) }
  it { expect(subject).to validate_inclusion_of(:mode).in_array(%w(regular play-off)) }

  it 'trigger removing matches on team association destroy' do
    round.teams.each_cons(2) do |host, guest|
      FactoryGirl.create(:match, round: round, host_team: host, guest_team: guest)
    end

    expect(round).to receive(:destroy_matches).exactly(3).times.and_call_original
    expect { round.teams = [] }.to change(Match, :count).by(-2)
  end

  context '#generate_matches' do
    let(:generate_matches) { round.generate_matches(round.teams.pluck(:id), 1) }
    let(:generate_multiple_matches) { round.generate_matches(round.teams.pluck(:id), 3) }

    it 'should accept team_ids and games_count as attributes' do
      expect { round.generate_matches }.to raise_error(ArgumentError, /expected 1..2/)
    end

    it 'should return Array of matches' do
      expect(generate_matches).to be_kind_of(Array)
      expect(generate_matches.all? { |m| m.kind_of?(Match) }).to be_truthy
    end

    it 'should generate specified number of matches' do
      expect { generate_matches }.to change { round.matches.count }.by(3)
      expect { generate_multiple_matches }.to change { round.matches.count }.by(9)
    end

    it 'should change host and guest for each pair of matches' do
      id = round.teams.first.id

      expect { generate_multiple_matches }.to change { Match.where(host_team_id: id).count }.by(2)
    end
  end

  context '#stats' do
    before(:all) do
      @round = FactoryGirl.create(:round)
      teams = FactoryGirl.create_list(:team, 4)
      @round.teams << teams

      [[teams[0], teams[1], 5, 5],
       [teams[0], teams[2], 5, 9],
       [teams[2], teams[1], 9, 3]].each do |t1, t2, score1, score2|
        FactoryGirl.create(:match, host_team: t1,
                           guest_team: t2,
                           host_score: score1,
                           guest_score: score2,
                           round: @round)
      end
    end

    let(:round_stats) { @round.stats }

    it 'should return Array of teams' do
      expect(round_stats).to be_kind_of(Array)
      expect(round_stats.all? { |m| m.kind_of?(Team) }).to be_truthy
    end

    it 'should assign points to each team' do
      expect(round_stats.map(&:points)).to eq([6, 1, 1, 0])
    end

    it 'should assign games_total to each team' do
      expect(round_stats.map(&:games_total)).to eq([2, 2, 2, 0])
    end

    it 'should assign games_won to each team' do
      expect(round_stats.map(&:games_won)).to eq([2, 0, 0, 0])
    end

    it 'should assign games_draw to each team' do
      expect(round_stats.map(&:games_draw)).to eq([0, 1, 1, 0])
    end

    it 'should assign goals_scored to each team' do
      expect(round_stats.map(&:goals_scored)).to eq([18, 10, 8, 0])
    end

    it 'should assign goals_against to each team' do
      expect(round_stats.map(&:goals_against)).to eq([8, 14, 14, 0])
    end

    it 'should be ordered by points and goals_diff' do
      ids = @round.teams.pluck(:id)

      expect(round_stats.map(&:id)).to eq([ids[2], ids[0], ids[1], ids[3]])
    end
  end
end
