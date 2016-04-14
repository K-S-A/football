json.(@round, :id, :mode)
json.teams do
  json.array! @teams do |team|
    json.(team, :id, :name, :games_total, :games_won, :games_draw, :goals_scored, :goals_against, :points, :goals_diff)
  end
end
