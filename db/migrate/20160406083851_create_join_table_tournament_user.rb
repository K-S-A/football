class CreateJoinTableTournamentUser < ActiveRecord::Migration
  def change
    create_join_table :tournaments, :users do |t|
      t.index [:tournament_id, :user_id]
      t.index [:user_id, :tournament_id]
    end
  end
end
