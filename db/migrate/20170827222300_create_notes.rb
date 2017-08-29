class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.references :list, foreign_key: true
      t.string :title, null: false, limit: 128
      t.string :slug, null: false, limit: 128
      t.text :content
      t.integer :order, index: true

      t.timestamps
    end
  end
end
