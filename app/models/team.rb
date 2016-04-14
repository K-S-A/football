class Team < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users
  has_and_belongs_to_many :rounds

  def matches
    Match.where('host_team_id = :id OR guest_team_id = :id', id: id)
  end

  class << self
    def batch_generate(tournament_id, team_size)
      # generate teams
      tournament = Tournament.includes(:users).find(tournament_id)
      teams = generate_teams(tournament, team_size)

      # generate teams_params
      teams_params = teams.each.with_object([]) do |team, obj|
        obj.push(name: team.map(&:short_name).join(' + '),
                 user_ids: team.map(&:id))
      end

      # insert teams/users
      tournament.teams.create(teams_params)
    end

    def round_stats(round_id)
      Team.find_by_sql(round_stats_query(round_id))
    end

    private

    def generate_teams(tournament, team_size)
      participants = tournament.users

      participants
        .in_groups_of(participants.length / team_size)[0..team_size - 1]
        .map(&:shuffle)
        .transpose
    end

    def round_stats_query(round_id)
      %{SELECT *,
        (games_won * 3 + games_draw) AS points,
        (goals_scored - goals_against) AS goals_diff
      FROM(
        SELECT
          teams.id AS id,
          teams.name AS name,
          SUM(CASE
            WHEN matches.host_score IS NULL OR matches.guest_score IS NULL THEN 0
            ELSE 1
            END) AS games_total,
          SUM(CASE
            WHEN teams.id = matches.host_team_id AND matches.host_score > matches.guest_score OR
              teams.id = matches.guest_team_id AND matches.host_score < matches.guest_score THEN 1
            ELSE 0
            END) AS games_won,
          SUM(CASE
            WHEN matches.host_score = matches.guest_score THEN 1
            ELSE 0
            END) AS games_draw,
          SUM(CASE
            WHEN matches.host_score IS NULL OR matches.guest_score IS NULL THEN 0
            WHEN teams.id = matches.host_team_id THEN matches.host_score
            ELSE matches.guest_score
            END) AS goals_scored,
          SUM(CASE
            WHEN matches.host_score IS NULL OR matches.guest_score IS NULL THEN 0
            WHEN teams.id = matches.host_team_id THEN matches.guest_score
            ELSE matches.host_score
            END) AS goals_against
        FROM teams
          JOIN matches
          ON teams.id = matches.guest_team_id OR teams.id = matches.host_team_id
        WHERE matches.round_id = #{round_id}
        GROUP BY teams.id) AS data
      ORDER BY points DESC, goals_diff DESC}
    end
  end
end
