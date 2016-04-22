class Round < ActiveRecord::Base
  belongs_to :tournament
  has_many :matches, dependent: :destroy
  has_and_belongs_to_many :teams, after_remove: :destroy_matches

  def destroy_matches(team)
    matches.where('host_team_id = :id OR guest_team_id = :id', id: team.id).destroy_all
  end

  def generate_matches(team_ids, games_count = 1)
    transaction do
      team_ids.each.with_index(1).with_object([]) do |(t1, index), arr|
        team_ids[index..-1].each do |t2|
          games_count.times do |i|
            host_team_id, guest_team_id = i.odd? ? [t1, t2] : [t2, t1]

            arr << matches.create(host_team_id: host_team_id,
                                  guest_team_id: guest_team_id)
          end
        end
      end
    end
  end

  def stats
    Team.find_by_sql(round_stats_query(id))
  end

  private

  def round_stats_query(round_id)
    # TODO: refactor nested subqueries
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
        JOIN rounds_teams
        ON rounds_teams.team_id = teams.id AND rounds_teams.round_id = #{round_id}
        LEFT JOIN matches
        ON (teams.id = matches.guest_team_id OR teams.id = matches.host_team_id) AND matches.round_id = #{round_id}
      GROUP BY teams.id) AS data
    ORDER BY points DESC, goals_diff DESC}
  end
end
