class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :caption
      t.boolean :is_status, null: false, default: true
      t.integer :type, null: false

      t.timestamps
    end
  end
end
