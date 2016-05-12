class Tournament < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_and_belongs_to_many :users, after_remove: :destroy_teams

  default_scope { order(id: :desc) }

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 254 },
                   uniqueness: { case_sensitive: false }
  validates :status, presence: true,
                     inclusion: { in: %w(not\ started completed in\ progress closed) }
  validates :sports_kind, presence: true
  validates :team_size, presence: true,
                        inclusion: { in: 1..20 }

  def rated_by?(user_id)
    assessments.where(user_id: user_id).any?
  end

  def rank_users
    return if users.count.zero?

    transaction do
      users.each { |user| user.update_rank_from(self) }
      assessments.destroy_all
    end
  end

  def generate_teams
    return if users.count < team_size
    teams.create!(teams_params)
  end

  class << self
    def unrated_by(user)
      find_by_sql(unrated_tournaments_query(user.id))
    end

    private

    def unrated_tournaments_query(user_id)
      %(SELECT DISTINCT tournaments.*
      FROM tournaments
        JOIN tournaments_users
        ON tournaments.id = tournaments_users.tournament_id
          LEFT JOIN assessments
          ON tournaments.id = assessments.tournament_id
      WHERE assessments.id IS NULL AND tournaments.status = 'completed' AND tournaments_users.user_id = #{user_id})
    end
  end

  private

  def teams_params
    shuffled_users.each.with_object([]) do |team, obj|
      obj.push(name: team.map(&:short_name).join(' + '),
               user_ids: team.map(&:id))
    end
  end

  def shuffled_users
    users
      .order(rank: :desc)
      .in_groups_of(users.count / team_size)[0..team_size - 1]
      .map(&:shuffle)
      .transpose
  end

  def destroy_teams(user)
    user.teams.where(tournament_id: id).destroy_all
  end
end
