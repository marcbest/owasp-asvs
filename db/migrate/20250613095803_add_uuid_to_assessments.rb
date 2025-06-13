class AddUuidToAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :assessments, :uuid, :string
    add_index :assessments, :uuid, unique: true
  end
end
