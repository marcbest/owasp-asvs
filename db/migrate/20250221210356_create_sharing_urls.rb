class CreateSharingUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :sharing_urls do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :uuid
      t.datetime :expires_at
      t.string :description

      t.timestamps
    end
  end
end
