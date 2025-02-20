class AddOwaspFieldsToRequirements < ActiveRecord::Migration[8.0]
  def change
    add_column :requirements, :l1_required, :boolean
    add_column :requirements, :l1_requirement, :string
    add_column :requirements, :l2_required, :boolean
    add_column :requirements, :l2_requirement, :string
    add_column :requirements, :l3_required, :boolean
    add_column :requirements, :l3_requirement, :string
    add_column :requirements, :cwe, :text
    add_column :requirements, :nist, :text
  end
end
