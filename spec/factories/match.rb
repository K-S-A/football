FactoryGirl.define do
  factory :match do
    host_score { Faker::Number.between(1, 10) }
    guest_score { Faker::Number.between(1, 10) }
    host_team
    guest_team
    round
  end
end
