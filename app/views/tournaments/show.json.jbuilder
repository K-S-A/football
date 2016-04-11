json.partial! 'tournaments/tournament', tournament: @tournament
json.teams @tournament.teams, partial: 'teams/team', as: :team
