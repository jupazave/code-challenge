# frozen_string_literal: true

class CreateInvoiceUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_uploads do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
