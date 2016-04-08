class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :score
      t.references :user, index: true, foreign_key: true
      t.integer :rated_user_id, index: true, null: false
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
