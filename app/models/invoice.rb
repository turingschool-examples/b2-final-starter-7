class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.total_discounted_revenue(invoice_id)
    joins(items: { merchant: :bulk_discounts })
      .where("invoices.id = ?", invoice_id)
      .sum("CASE
             WHEN invoice_items.quantity > bulk_discounts.quantity_threshold
             THEN (invoice_items.quantity * (invoice_items.unit_price * (1 - COALESCE(bulk_discounts.percentage, 0) / 100)))
             ELSE (invoice_items.quantity * invoice_items.unit_price)
           END")
  end
end
