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

      # generate teams_params for batch insert
      teams_params = users_teams.each.with_object([]) do |team, obj|
        obj.push("('#{team.map(&:short_name).join(' + ')}',\
                  #{tournament_id},\
                  '#{Time.current}',\
                  '#{Time.current}')")
      end

      # insert teams and get IDs of inserted teams
      teams = insert_teams(teams_params)

      # insert HBTM users/teams relations
      teams_users_params = teams.each.with_index.with_object([]) do |(team, index), obj|
        users_teams[index].each do |user|
          obj.push("(#{user.id}, #{team.id})")
        end
      end

      insert_teams_users(teams_users_params)

      teams
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

    # => Array of inserted Teams IDs
    def insert_teams(teams_params)
      # TODO: sanitize params
      query = <<END_SQL
        INSERT INTO teams
          (name, tournament_id, created_at, updated_at)
        VALUES #{teams_params.join(', ')}
        RETURNING teams.id, teams.name
END_SQL

      Team.find_by_sql(query)
    end

    def insert_teams_users(teams_users_params)
      query = <<END_SQL
        INSERT INTO teams_users
        VALUES #{teams_users_params.join(', ')}
END_SQL

      Team.find_by_sql(query)
    end
  end
end
