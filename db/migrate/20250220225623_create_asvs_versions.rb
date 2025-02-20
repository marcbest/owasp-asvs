class CreateAsvsVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :asvs_versions do |t|
      t.string :name
      t.string :version
      t.text :description
      t.text :json_data

      t.timestamps
    end
  end
end
