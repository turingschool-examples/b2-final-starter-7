class Merchant < ApplicationRecord
  # include ActiveModel::Validations

  validates_presence_of :name

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :coupons

  # validate :max_coupons_have_not_been_reached
  # validates :active_coupon_count, length: { maximum: 5 }

  enum status: [:enabled, :disabled]

  # def max_coupons_have_not_been_reached
  #   return unless active_coupon_protection? # nothing to validate
  #   errors.add_to_base("Max Number of Acitve Coupons Reached: 5") unless merchant.active_coupon_count < merchant.maximum_amount_of_coupons
  # end

  # def active_coupon_count
  #   coupons.where("status = 0").size
  # end

  # def maximum_amount_of_coupons
  #   5
  # end

  # validate do
  #   if self.active_coupon_count >= 5
  #     errors.add(:base, "Too Many Active Coupons") if self.active_coupon_protection? == true
  #     return
  #   end
  # end

  def favorite_customers
    transactions.joins(invoice: :customer)
                .where('result = ?', 1)
                .where("invoices.status = ?", 2)
                .select("customers.*, count('transactions.result') as top_result")
                .group('customers.id')
                .order(top_result: :desc)
                .distinct
                .limit(5)
  end

  def ordered_items_to_ship
    item_ids = InvoiceItem.where("status = 0 OR status = 1").order(:created_at).pluck(:item_id)
    item_ids.map do |id|
      Item.find(id)
    end
  end

  def top_5_items
    items
    .joins(invoices: :transactions)
    .where('transactions.result = 1')
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .group(:id)
    .order('total_revenue desc')
    .limit(5)
   end

  def self.top_merchants
    joins(invoices: [:invoice_items, :transactions])
    .where('result = ?', 1)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .group(:id)
    .order('total_revenue DESC')
    .limit(5)
  end

  def best_day
    invoices.where("invoices.status = 2")
            .joins(:invoice_items)
            .select('invoices.created_at, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
            .group("invoices.created_at")
            .order("revenue desc", "invoices.created_at desc")
            .first&.created_at&.to_date
  end

  def enabled_items
    items.where(status: 1)
  end

  def disabled_items
    items.where(status: 0)
  end

  def active_coupon_protection?
    coupons.where("coupons.status = 0").size >= 5
  end
end
