json.(tournament, :id, :name, :status, :sports_kind, :team_size)

json.users do
  json.array!(tournament.users, :id, :first_name, :last_name, :img_link, :admin, :rank)
end

json.rounds do
  json.array! tournament.rounds, partial: 'rounds/round', as: :round
end
