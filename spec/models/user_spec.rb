require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = FactoryGirl.create(:user, first_name: 'John', last_name: 'Doe')
    @completed_tournaments = FactoryGirl.create_list(:completed_tournament, 3)
    FactoryGirl.create_list(:inprogress_tournament, 3)
  end

  context '#short_name' do
    it 'returns string with users first_name and first letter of last_name' do
      expect(@user.short_name).to eq('John D.')
    end
  end

  context '#unrated_tournaments' do
    subject { @user.unrated_tournaments }

    it 'should return Array' do
      expect(subject).to be_kind_of(Array)
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
