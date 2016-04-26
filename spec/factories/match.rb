FactoryGirl.define do
  factory :match do
    host_score { Faker::Number.between(1, 10) }
    guest_score { Faker::Number.between(1, 10) }
    host_team
    guest_team
    round

    factory :invalid_match do
      host_score(-1)
      guest_score(-99)
    end
  end
end
