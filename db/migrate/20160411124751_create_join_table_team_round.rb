class CreateJoinTableTeamRound < ActiveRecord::Migration
  def change
    create_join_table :teams, :rounds do |t|
      t.index [:team_id, :round_id]
      t.index [:round_id, :team_id]
    end
  end
end
