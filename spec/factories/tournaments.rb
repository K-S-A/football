FactoryGirl.define do
  factory :tournament do
    sequence(:name) { |i| "#{Faker::App.name}-#{i}" }
    status { %w(not\ started completed in\ progress).sample }
    sports_kind { Faker::Team.sport }
    team_size { [1, 2, 3, 4, 5].sample }

    factory :completed_tournament do
      status 'completed'
    end

    factory :inprogress_tournament do
      status 'in progress'
    end

    factory :tournament_with_assessments do
      status 'completed'

      transient do
        assessments_count 5
      end

      after(:create) do |tournament, evaluator|
        create_list(:assessment, evaluator.assessments_count, tournament: tournament)
      end
    end

    factory :tournament_with_participants do
      transient do
        users_count 5
      end

      after(:create) do |tournament, evaluator|
        create_list(:user, evaluator.users_count, tournaments: [tournament])
      end
    end

    factory :invalid_tournament do
      sports_kind nil
      team_size nil
    end
  end
end
