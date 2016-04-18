require 'rails_helper'

RSpec.describe Assessment, type: :model do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:tournament) }
end
