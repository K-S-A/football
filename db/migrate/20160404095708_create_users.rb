class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :img_link
      t.integer :rank

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
