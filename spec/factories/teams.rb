FactoryGirl.define do
  factory :team, aliases: [:host_team, :guest_team] do
    name { Faker::Team.name }
    tournament

    factory :invalid_team do
      name nil
    end

    factory :team_with_matches do
      transient do
        matches_count 5
      end

      after(:create) do |team, evaluator|
        create_list(:match, evaluator.matches_count, host_team: team)
        create_list(:match, evaluator.matches_count, guest_team: team)
      end
    end
  end
end
