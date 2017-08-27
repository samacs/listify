class AddTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :string, limit: 128
  end
end
