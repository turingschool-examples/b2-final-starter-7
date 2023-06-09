class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :discount_amount,
                        :discount_type

  validates :discount_amount, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validates_uniqueness_of :unique_code, on: :create

  belongs_to :merchant
  has_many :invoices
  # validates_associated :merchant
  # validate :active_coupon_count

  enum status: [:enabled, :disabled]
  enum discount_type: [:dollars, :percentage]

  # def active_coupon_count(merchant_id)
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

end