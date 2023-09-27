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
  
  def discounted_revenue
    invoice_items.inject(0){|revenue, invoice_item| 
      if invoice_item.item.applicable_discount(invoice_item.quantity)
        revenue + invoice_item.quantity * invoice_item.unit_price * (1 - invoice_item.item.applicable_discount(invoice_item.quantity).percentage / 100)
      else
        revenue + invoice_item.quantity * invoice_item.unit_price
      end}
    end
end
