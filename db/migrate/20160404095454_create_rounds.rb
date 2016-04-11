class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :tournament, index: true, foreign_key: true
      t.string :mode,      null: false, default: 'regular'
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end
  end
end
