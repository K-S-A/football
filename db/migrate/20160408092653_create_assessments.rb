class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :score
      t.references :user, index: true, foreign_key: true
      t.integer :rated_user_id, index: true, null: false
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :assessments, [:user_id, :rated_user_id, :tournament_id], unique: true, name: 'index_assessments_on_user_and_tournament'
  end
end
