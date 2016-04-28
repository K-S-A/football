require 'rails_helper'

RSpec.describe Match, type: :model do
  it { expect(subject).to belong_to(:round) }
  it { expect(subject).to belong_to(:host_team).class_name('Team') }
  it { expect(subject).to belong_to(:guest_team).class_name('Team') }

  it { expect(subject).to validate_numericality_of(:host_score).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value('', nil).for(:host_score) }
  it { expect(subject).to validate_numericality_of(:guest_score).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value('', nil).for(:guest_score) }
end
