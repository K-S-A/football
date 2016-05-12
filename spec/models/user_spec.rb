require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = FactoryGirl.create(:user, first_name: 'John', last_name: 'Doe')
  end

  context '#short_name' do
    it 'returns string with users first_name and first letter of last_name' do
      expect(@user.short_name).to eq('John D.')
    end
  end

  context '#update_rank_from' do
    before(:all) do
      @tournament = FactoryGirl.create(:tournament_with_participants)
      @rated_user = FactoryGirl.create(:user)
      @assessments = @tournament.users.each.with_index do |user, index|
        FactoryGirl.create(:assessment, tournament: @tournament,
                                        user: user,
                                        rated_user: @rated_user,
                                        score: index)
      end
    end

    let(:call_method) { @rated_user.update_rank_from(@tournament) }

    it 'should update users rank' do
      expect { call_method }.to change { @rated_user.rank }.from(nil).to(600)
    end
  end

  context 'abilities' do
    subject { Ability.new(user) }
    let(:user) { nil }

    context 'with admin user' do
      let(:user) { FactoryGirl.create(:admin) }

      it { expect(subject).to be_able_to(:manage, Tournament) }
      it { expect(subject).to be_able_to(:manage, Round) }
      it { expect(subject).to be_able_to(:manage, Match) }
      it { expect(subject).to be_able_to(:manage, Team) }
      it { expect(subject).to be_able_to(:manage, User) }
      it { expect(subject).to be_able_to(:remove_team, Round) }
      it { expect(subject).to be_able_to(:index_teams, Round) }
      it { expect(subject).to be_able_to(:index_teams, Tournament) }
      it { expect(subject).to be_able_to(:remove_user, Team) }
      it { expect(subject).to be_able_to(:generate, Team) }
      it { expect(subject).to be_able_to(:destroy_teams, Tournament) }
      it { expect(subject).to be_able_to(:join, Tournament) }
      it { expect(subject).to be_able_to(:remove_user, Tournament) }
    end

    context 'with regular user' do
      let(:user) { FactoryGirl.create(:user) }

      include_examples 'for read-only abilities'
      it { expect(subject).to be_able_to(:update, Tournament) }
      it { expect(subject).to be_able_to(:create, Assessment) }
      it { expect(subject).not_to be_able_to(:index, User) }
      it { expect(subject).to be_able_to(:show, User) }
      it { expect(subject).not_to be_able_to(:remove_team, Round) }
      it { expect(subject).to be_able_to(:index_teams, Round) }
      it { expect(subject).to be_able_to(:index_teams, Tournament) }
      it { expect(subject).not_to be_able_to(:remove_user, Team) }
      it { expect(subject).not_to be_able_to(:generate, Team) }
      it { expect(subject).not_to be_able_to(:destroy_teams, Tournament) }
      it { expect(subject).to be_able_to(:join, Tournament) }
      it { expect(subject).not_to be_able_to(:remove_user, Tournament) }
    end

    context 'with unregistered user' do
      include_examples 'for read-only abilities'

      it { expect(subject).not_to be_able_to(:update, Tournament) }
      it { expect(subject).not_to be_able_to(:index, User) }
      it { expect(subject).to be_able_to(:show, User) }
      it { expect(subject).not_to be_able_to(:remove_team, Round) }
      it { expect(subject).to be_able_to(:index_teams, Round) }
      it { expect(subject).to be_able_to(:index_teams, Tournament) }
      it { expect(subject).not_to be_able_to(:remove_user, Team) }
      it { expect(subject).not_to be_able_to(:generate, Team) }
      it { expect(subject).not_to be_able_to(:destroy_teams, Tournament) }
      it { expect(subject).not_to be_able_to(:join, Tournament) }
      it { expect(subject).not_to be_able_to(:remove_user, Tournament) }
    end
  end
end
