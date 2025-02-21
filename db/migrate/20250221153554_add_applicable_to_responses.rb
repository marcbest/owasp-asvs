class AddApplicableToResponses < ActiveRecord::Migration[8.0]
  def change
    add_column :responses, :applicable, :boolean
  end
end
