class CreateAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :assessments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :asvs_version, null: false, foreign_key: true

      t.timestamps
    end
  end
end
