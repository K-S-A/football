class AddFirstNameLastNameImgLinkRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :img_link, :string
    add_column :users, :rank, :integer
    add_column :users, :admin, :boolean, default: false
  end
end
