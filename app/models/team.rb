class Team < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users

  def matches
    Match.where('host_team_id = :team_id OR guest_team_id = :team_id', team_id: id)
  end

  class << self
    def batch_generate(tournament_id, team_size)
      # get tournament participants
      users_teams = tournament_teams(tournament_id, team_size)

      # generate teams_params
      teams_params = users_teams.each.with_object([]) do |team, obj|
        obj.push(name: team.map(&:short_name).join(' + '),
                 tournament_id: tournament_id,
                 user_ids: team.map(&:id))
      end

      # insert teams/users
      teams = insert_teams(teams_params)
    end

    private

    # => Array of Users (participants of Tournament)
    def tournament_users(tournament_id)
      # TODO: sanitize params
      query = <<END_SQL
        SELECT DISTINCT users.id, users.first_name, users.last_name, users.rank
        FROM users
          JOIN tournaments_users
          ON users.id = tournaments_users.user_id
        WHERE tournaments_users.tournament_id = #{tournament_id}
        ORDER BY users.rank
END_SQL

      User.find_by_sql(query)
    end

    # => Array of Users grouped by Teams
    def tournament_teams(tournament_id, team_size)
      participants = tournament_users(tournament_id)
      teams_count = participants.length / team_size

      groups = participants.in_groups_of(teams_count, false)
      groups.pop if groups.last.size < team_size

      groups[1..-1].each(&:shuffle!)

      groups.transpose
    end

    # => Array of inserted Teams
    def insert_teams(teams_params)
      teams = Team.create(teams_params)
      # preload :users
      ActiveRecord::Associations::Preloader.new.preload(teams, :users)

      teams
    end
  end
end
