json.(tournament, :id, :name, :status, :game_type, :team_size)
json.users do
  json.array!(tournament.users, :id, :first_name, :last_name, :img_link, :admin, :rank)
end
