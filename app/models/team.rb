class Team < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users

  def matches
    Match.where('host_team_id = :team_id OR guest_team_id = :team_id', team_id: id)
  end

  class << self
    def batch_generate(tournament_id, team_size)
      # get tournament participants
      tournament = Tournament.includes(:users).find(tournament_id)

      # generate teams
      teams = generate_teams(tournament, team_size)

      # generate teams_params
      teams_params = teams.each.with_object([]) do |team, obj|
        obj.push(name: team.map(&:short_name).join(' + '),
                 user_ids: team.map(&:id))
      end

      # insert teams/users
      tournament.teams.create(teams_params)
    end

    private

    def generate_teams(tournament, team_size)
      participants = tournament.users

      participants
        .in_groups_of(participants.length / team_size)[0..team_size - 1]
        .map(&:shuffle)
        .transpose
    end
  end
end
