# frozen_string_literal: true

class CreateBusinesses < ActiveRecord::Migration[6.1]
  def change
    create_table :businesses do |t|
      t.string :tax_name
      t.string :tax_id

      t.timestamps
    end
  end
end
