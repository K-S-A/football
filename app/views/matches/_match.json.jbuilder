json.(match, :id, :host_score, :guest_score, :next_id)

if match.host_team
  json.host_team do
    json.partial! 'teams/team', team: match.host_team
  end
end

if match.guest_team
  json.guest_team do
      json.partial! 'teams/team', team: match.guest_team
  end
end
