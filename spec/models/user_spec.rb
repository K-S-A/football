require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user, first_name: 'John', last_name: 'Doe') }

  context '#short_name' do
    it 'returns string with users first_name and first letter of last_name' do
      expect(user.short_name).to eq('John D.')
    end
  end
end
