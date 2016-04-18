require 'rails_helper'

RSpec.describe Team, type: :model do
  it { expect(subject).to belong_to(:tournament) }
end
