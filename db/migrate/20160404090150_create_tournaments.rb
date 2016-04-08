class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name,   null: false
      t.string :status, null: false, default: 'not started'
      t.string :sports_kind, null: false
      t.integer :team_size, null: false, default: 1

      t.timestamps null: false
    end

    add_index :tournaments, :name, unique: true
  end
end
