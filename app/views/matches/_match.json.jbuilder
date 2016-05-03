json.(match, :id, :host_score, :guest_score, :next_id)

json.host_team do
  json.partial! 'teams/team', team: match.host_team
end

json.guest_team do
  json.partial! 'teams/team', team: match.guest_team
end
