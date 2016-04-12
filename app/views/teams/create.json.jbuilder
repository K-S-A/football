if @team
  json.partial! 'teams/team', team: @team
else
  json.array! @teams, partial: 'teams/team', as: :team
end
