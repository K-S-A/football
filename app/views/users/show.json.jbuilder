json.(@user, :id, :first_name, :last_name, :img_link, :admin)
json.tournaments @user.tournaments, partial: 'tournaments/tournament', as: :tournament
json.teams @user.teams, partial: 'teams/team', as: :team
