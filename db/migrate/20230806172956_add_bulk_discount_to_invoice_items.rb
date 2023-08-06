class AddBulkDiscountToInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :bulk_discounts, :invoice_item, foreign_key: true
  end
end
