json.(round, :id, :mode)
json.teams do
  json.array! round.teams, partial: 'teams/team', as: :team
end
