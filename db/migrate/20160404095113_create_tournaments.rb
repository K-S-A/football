class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name, 	null: false
      t.string :status, null: false, default: 'not started'

      t.timestamps null: false
    end
  end
end
