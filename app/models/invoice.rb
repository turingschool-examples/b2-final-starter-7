class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def revenue_discounted

    @total = 0.0

    invoice_items.each do |item|

      cost = item.unit_price

      best_discount = bulk_discounts.where("quantity_threshold <= ?", item.quantity).order(quantity_threshold: :desc).first

      if best_discount 
        cost -= (cost * (best_discount.percentage_discount / 100.0))
      end 
      
      @total += cost * item.quantity
    end 
    @total
  end
end
