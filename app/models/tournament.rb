class Tournament < ActiveRecord::Base
  RANK_CORRELATION = 1000

  has_many :rounds
  has_many :teams
  has_many :assessments
  has_and_belongs_to_many :users

  default_scope { order(id: :desc) }

  # TODO: move to controller?
  def rated_by?(user_id)
    assessments.where(user_id: user_id).count > 0
  end

  def rank_users
    max_score = users.count

    users.each do |user|
      rankings = Assessment.where(tournament_id: id, rated_user_id: user.id)
      score = rankings.average(:score) || max_score
      user.rank = (1 - score / max_score) * RANK_CORRELATION

      user.save
    end

    assessments.destroy_all
  end

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
      WHERE assessments.id IS NULL AND tournaments.status = 'completed'}
    end
  end
end
