require 'rails_helper'

RSpec.describe Match, type: :model do
  it { expect(subject).to belong_to(:round) }
  it { expect(subject).to belong_to(:host_team).class_name('Team') }
  it { expect(subject).to belong_to(:guest_team).class_name('Team') }
end
