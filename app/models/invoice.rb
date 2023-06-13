class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: [:cancelled, :in_progress, :completed]

  def sub_total
    invoice_items.sum("unit_price * quantity")
  end

  def discount_total
    if coupon.blank?
      0.0
    elsif coupon.discount_type == "dollars"
      coupon.discount_amount.to_f
    elsif coupon.discount_type == "percentage"
      coupon.discount_amount.to_f/100 * sub_total
    end
  end

  def grand_total_revenue
    if sub_total - discount_total < 0.0
      0.0
    else
      sub_total - discount_total
    end
  end
end
