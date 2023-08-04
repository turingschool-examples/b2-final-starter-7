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
    total_revenue - total_discount
  end

  def total_discount
    invoice_items.joins(item: { merchant: :discounts })
                .where('discounts.threshold <= invoice_items.quantity')
                .group('invoice_items.id')
                .pluck(Arel.sql('MAX(discounts.percentage) * invoice_items.unit_price * invoice_items.quantity / 100.0'))
                .sum
  end
end
