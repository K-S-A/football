class AddListOrderToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :list_order, :integer
  end
end
