# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.uuid :session_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sessions, :session_id, unique: true
  end
end
