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

  def total_discounted_revenue
  invoice_items.sum{ |ii| ii.final_price }
  end
end

  # def find_discounts
  #   invoice_items
  #   .joins(:items [:merchants, :bulk_discounts])
  #   .where('bulk_discounts.quantity_threshold <= ?', self.quantity)
  #   .select("bulk_discounts.*")
  #   .group(:id)
  #   .order("bulk_discounts.percentage_discount DESC")
  #   .limit(1)
  #   .first
  # end

  # def total_discounted_revenue
  #   invoice_items.sum("total_revenue * eligible_discount.multiplier")
  # end