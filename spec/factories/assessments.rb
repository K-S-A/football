FactoryGirl.define do
  factory :assessment do
    score { Faker::Number.between(1, 10) }
    user
    rated_user
    tournament

    factory :invalid_assessment do
      rated_user nil
    end
  end
end
