# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :public_id

      t.string    :token, null: false, default: ''
      t.datetime  :token_created_at

      t.timestamps null: false
    end

    add_index :users, :email,     unique: true
    add_index :users, :public_id, unique: true
    add_index :users, :token,     unique: true
  end
end
