require 'rails_helper'

RSpec.describe Tournament, type: :model do
  it { expect(subject).to have_many(:rounds) }
  it { expect(subject).to have_many(:teams) }
  it { expect(subject).to have_many(:assessments) }
end
