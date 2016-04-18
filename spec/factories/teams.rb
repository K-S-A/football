FactoryGirl.define do
  factory :team, aliases: [:host_team, :guest_team] do
    name { Faker::Team.name }
    tournament
  end
end
