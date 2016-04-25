FactoryGirl.define do
  factory :assessment do
    score { Faker::Number.between(1, 10) }
    user
    rated_user
    tournament
  end
end
