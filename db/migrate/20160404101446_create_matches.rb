class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :round, index: true, foreign_key: true
      t.integer :host_score
      t.integer :guest_score
      t.integer :host_team_id,  index: true
      t.integer :guest_team_id, index: true
      t.integer :next_id, index: true
      t.integer :grid

      t.timestamps null: false
    end
  end
end
