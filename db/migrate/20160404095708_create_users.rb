class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :img_link
      t.integer :rank

      t.timestamps null: false
    end
  end
end
