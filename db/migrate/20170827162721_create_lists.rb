class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string :name, null: false, limit: 256
      t.string :slug, null: false, limit: 256, unique: true
      t.text :description
      t.references :owner, references: :users

      t.timestamps
    end
  end
end
