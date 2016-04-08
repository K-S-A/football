class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :tournament, index: true, foreign_key: true
      t.string :mode, null: false, default: 'regular'

      t.timestamps null: false
    end
  end
end
