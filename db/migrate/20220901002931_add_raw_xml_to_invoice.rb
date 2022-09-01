# frozen_string_literal: true

class AddRawXmlToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :raw_xml, :text
  end
end
