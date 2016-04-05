class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name,   null: false
      t.string :status, null: false, default: 'not started'

      t.timestamps null: false
    end

    add_index :tournaments, :name, unique: true
  end
end
