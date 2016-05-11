class Tournament < ActiveRecord::Base
  RANK_CORRELATION = 1000

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

  # TODO: move to controller?
  def rated_by?(user_id)
    assessments.where(user_id: user_id).any?
  end

  def rank_users
    max_score = users.count
    return if max_score.zero?

    users.each do |user|
      score = Assessment.where(tournament_id: id, rated_user_id: user.id).average(:score) || next
      user.rank = (1 - score / max_score) * RANK_CORRELATION

      user.save
    end

    assessments.destroy_all
  end

  def generate_teams
    return if users.count < team_size
    teams.create!(teams_params)
  end

  private

  def teams_params
    # shuffle tournament participants
    new_teams = users
                .order(rank: :desc)
                .in_groups_of(users.count / team_size)[0..team_size - 1]
                .map(&:shuffle)
                .transpose

    # generate teams_params
    new_teams.each.with_object([]) do |team, obj|
      obj.push(name: team.map(&:short_name).join(' + '),
               user_ids: team.map(&:id))
    end
  end

  def destroy_teams(user)
    user.teams.where(tournament_id: id).destroy_all
  end
end
