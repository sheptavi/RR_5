class CreateAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :assessments do |t|
      t.references :image, null: false, foreign_key: true
      t.integer :value
      t.integer :user_id

      t.timestamps
    end
  end
end
