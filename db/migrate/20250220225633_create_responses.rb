class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :requirement, null: false, foreign_key: true
      t.boolean :met_requirement
      t.text :comment

      t.timestamps
    end
  end
end
