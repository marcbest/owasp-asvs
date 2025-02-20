class CreateRequirements < ActiveRecord::Migration[8.0]
  def change
    create_table :requirements do |t|
      t.references :asvs_version, null: false, foreign_key: true
      t.integer :parent_id
      t.string :shortcode
      t.integer :ordinal
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
