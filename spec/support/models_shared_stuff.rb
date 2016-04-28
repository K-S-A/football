RSpec.shared_examples 'for read-only abilities' do
  it { expect(subject).not_to be_able_to(:manage, Tournament) }
  it { expect(subject).not_to be_able_to(:manage, Round) }
  it { expect(subject).not_to be_able_to(:manage, Match) }
  it { expect(subject).not_to be_able_to(:manage, Team) }
  it { expect(subject).to be_able_to(:read, Tournament) }
  it { expect(subject).to be_able_to(:read, Round) }
  it { expect(subject).to be_able_to(:read, Match) }
  it { expect(subject).to be_able_to(:read, Team) }
end
