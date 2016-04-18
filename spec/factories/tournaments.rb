FactoryGirl.define do
  factory :tournament do
    sequence(:name) { |i| "#{Faker::App.name}-#{i}" }
    status { %w(not\ started completed in\ progress).sample }
    sports_kind { Faker::Team.sport }
    team_size { [1,2,3,4,5].sample }
  end
end
