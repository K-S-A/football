require 'rails_helper'

RSpec.describe Assessment, type: :model do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:tournament) }
  it { expect(subject).to validate_presence_of(:user) }
end
