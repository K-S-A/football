require 'rails_helper'

RSpec.describe Round, type: :model do
  it { expect(subject).to belong_to(:tournament) }
  it { expect(subject).to have_many(:matches) }
  it { expect(subject).to have_and_belong_to_many(:teams) }

  it 'trigger removing matches on team association destroy' do
    round = FactoryGirl.create(:round_with_teams, teams_count: 3)

    round.teams.each_cons(2) do |host, guest|
      FactoryGirl.create(:match, round: round, host_team: host, guest_team: guest)
    end

    expect { round.teams = [] }.to change(Match, :count).by(-2)
  end
end
