class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :discount_amount,
                        :discount_type

  validates :discount_amount, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validates_uniqueness_of :unique_code, on: :create

  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices
  # validates_associated :merchant
  # validate :coupon_count

  enum status: [:enabled, :disabled]
  enum discount_type: [:dollars, :percentage]

  # validate :max_coupons_have_not_been_reached
  # validates :active_coupon_count, length: { maximum: 5 }

  # enum status: [:enabled, :disabled]

  # def max_coupons_have_not_been_reached
  #   return unless active_coupon_protection? # nothing to validate
  #   errors.add_to_base("Max Number of Acitve Coupons Reached: 5") unless self.merchant.active_coupon_count < self.merchant.maximum_amount_of_coupons
  # end

  # def active_coupon_count
  #   self.merchant.coupons.where("status = 0").size
  # end

  # def maximum_amount_of_coupons
  #   5
  # end

  # def active_coupon_count #(merchant_id)
  #   .select("coupons.*, COUNT('coupons.status = 0') AS active_coupons")
  #   .where("coupons.status = 0") # AND coupons.merchant_id = #{merchant_id}")
  #   .group(:merchant_id)

  #   if self.where("coupons.status = 0 AND coupons.merchant_id = #{merchant_id}").size == 5
  #     errors.add(:active_coupon_error, "Too Many Active Coupons")
  #   end
  #   # count = 0
  #   # coupons.map do |c|
  #   #   if c.status == 0
  #   #     count += 1
  #   #   end
  #   # end
  # end

  def number_of_successful_transactions
    transactions.where("result != 0").size
  end

  # def active_coupon_protection?
  #   self.merchant.coupons.where("coupons.status = 0").size >= 5
  # end

end