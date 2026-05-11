class CreateValues < ActiveRecord::Migration[7.1]
  def change
    create_table :values do |t|
      t.references :user, null: false, foreign_key: true
      t.references :image, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
