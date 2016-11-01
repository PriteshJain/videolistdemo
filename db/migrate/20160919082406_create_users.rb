class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string  :mobile_no , null: false
      t.string :auth_token , null: false
      t.string :active, default: false, null: false
      t.timestamps
    end
    add_index :users, :mobile_no, unique: true
    add_index :users, :auth_token, unique: true
  end
end
