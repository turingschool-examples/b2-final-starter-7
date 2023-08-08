class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discount
    max_discounts = invoice_items.select("invoice_items.id, MAX(discounts.percent_discount / 100.0) * invoice_items.unit_price * invoice_items.quantity as total_discount")
                                  .joins(item: { merchant: :discounts })
                                  .where("discounts.threshold_quantity <= invoice_items.quantity")
                                  .group("invoice_items.id")
    max_discounts.sum { |invoice_item| invoice_item.total_discount }  
  end

  def total_discounted_revenue
    total_revenue - total_discount
  end
end
