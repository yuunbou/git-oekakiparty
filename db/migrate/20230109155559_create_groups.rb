class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :content
      t.bigint :owner_id, index: true, null: false

      t.timestamps
    end
    add_foreign_key :groups, :users, column: :owner_id
  end
end
