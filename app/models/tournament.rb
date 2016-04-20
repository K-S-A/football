class Tournament < ActiveRecord::Base
  has_many :rounds
  has_many :teams
  has_many :assessments
  has_and_belongs_to_many :users

  class << self
    def unrated_tournaments(user_id)
      find_by_sql(unrated_tournaments_query(user_id))
    end

    private

    def unrated_tournaments_query(user_id)
      %{SELECT DISTINCT tournaments.*
      FROM tournaments
        LEFT JOIN assessments
        ON tournaments.id = assessments.tournament_id AND assessments.user_id = #{user_id}
      WHERE assessments.id IS NULL
      }
    end
  end
end
