class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 128
      t.string :email, null: false, limit: 128, index: :unique
      t.string :password_digest, null: false, limit: 72

      t.timestamps
    end
  end
end
