require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:team_with_matches) { FactoryGirl.create(:team_with_matches, matches_count: 3) }

  it { expect(subject).to belong_to(:tournament) }
  it { expect(subject).to have_and_belong_to_many(:users) }
  it { expect(subject).to have_and_belong_to_many(:rounds) }

  it 'should remove all team matches on destroy' do
    team_with_matches

    expect{ team_with_matches.destroy }.to change{ Match.count }.by(-6)
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
end
