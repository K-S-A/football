require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:team_with_matches) { FactoryGirl.create(:team_with_matches, matches_count: 3) }

  it { expect(subject).to belong_to(:tournament) }
  it { expect(subject).to have_and_belong_to_many(:users) }
  it { expect(subject).to have_and_belong_to_many(:rounds) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_length_of(:name).is_at_least(3) }

  it do
    expect(team_with_matches).to validate_uniqueness_of(:name)
      .scoped_to(:tournament_id)
      .case_insensitive
  end

  it 'should remove all team matches on destroy' do
    team_with_matches

    expect { team_with_matches.destroy }.to change { Match.count }.by(-6)
  end

  context '#matches' do
    it 'should return ActiveRecord::Relation' do
      expect(FactoryGirl.build(:team).matches).to be_kind_of(ActiveRecord::Relation)
    end

    it 'should return all matches where team is guest or host' do
      FactoryGirl.create_list(:match, 3)

      expect(team_with_matches.matches.size).to eq(6)
    end
  end

  context 'default scope' do
    it 'should order by :list_order' do
      tournament = FactoryGirl.create(:tournament)
      teams = FactoryGirl.create_list(:team, 3, tournament: tournament)
      teams[1].update_attribute(:list_order_position, :last)

      result = Tournament.find(tournament.id).teams
      expect(result).to eq([teams[0], teams[2], teams[1]])
    end
  end
end
