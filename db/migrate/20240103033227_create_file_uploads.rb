class CreateFileUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :file_uploads do |t|
      t.string :file_name
      t.string :file_type
      t.string :state, null: false, default: "pending"
      t.belongs_to :creator, foreign_key: { to_table: :spree_users }, index: true
      t.text :error_data
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
