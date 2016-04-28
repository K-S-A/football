require 'rails_helper'

RSpec.describe Assessment, type: :model do
  let(:assessment) { FactoryGirl.build(:assessment) }

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:tournament) }

  it { expect(subject).to validate_presence_of(:user) }

  it { expect(subject).to validate_presence_of(:score) }
  it { expect(assessment).to validate_uniqueness_of(:score).scoped_to([:user_id, :tournament_id]) }
end
