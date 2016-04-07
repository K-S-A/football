json.(team, :id, :name)
json.users do
  json.array!(team.users, :id, :first_name, :last_name, :img_link, :admin, :rank)
end
