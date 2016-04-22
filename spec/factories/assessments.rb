FactoryGirl.define do
  factory :assessment do
    score { Faker::Number.between(1, 10) }
    user
    rated_user_id 999
    tournament
  end
end
