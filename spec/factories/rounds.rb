FactoryGirl.define do
  factory :round do
    mode { %w(regular play-off).sample }

    factory :round_with_teams do
      transient do
        teams_count 3
      end

      after(:create) do |round, evaluator|
        create_list(:team, evaluator.teams_count, rounds: [round])
      end
    end

    factory :round_with_matches do
      transient do
        matches_count 3
      end

      after(:create) do |round, evaluator|
        create_list(:match, evaluator.matches_count, round: round)
      end
    end
  end
end
