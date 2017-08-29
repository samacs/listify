class AddOrderToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :order, :integer, null: false, default: 0
    add_index :lists, :order
  end
end
