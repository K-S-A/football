json.(tournament, :id, :name, :status, :sports_kind, :team_size)
json.users do
  json.array!(tournament.users, :id, :first_name, :last_name, :img_link, :admin, :rank)
end
json.rounds tournament.rounds, :id, :mode
