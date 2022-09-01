# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.references :business_emitter, null: false, foreign_key: { to_table: :businesses }
      t.references :business_receiver, null: false, foreign_key: { to_table: :businesses }
      t.string :status
      t.uuid :invoice_uuid
      t.decimal :amount_cents, null: false, default: 0
      t.string :amount_currency, null: false, default: 'MXN'

      t.date :emitted_at
      t.date :expires_at
      t.date :signed_at

      t.text :cfdi_digital_stamp

      t.timestamps
    end

    add_index :invoices, :invoice_uuid, unique: true
  end
end
