class Coupon < ApplicationRecord

  validates_presence_of :name,
                        :discount_amount,
                        :discount_type,
                        :status

  validates :discount_amount, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validates_uniqueness_of :unique_code, on: :create
  validate :validate_active_coupons, on: :create
  validate :validate_active_coupons_on_update, on: :update

  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices

  enum status: [:enabled, :disabled]
  enum discount_type: [:dollars, :percentage]

  def validate_active_coupons
    merchant = Merchant.find(self.merchant_id) unless self.merchant_id.nil?
    if self.status == "disabled" || self.status.nil?
      true
    else
      self.errors.add(:base, "Max Number of Active Coupons Reached: 5") if merchant.coupons.where("status = 0").size >= 5
    end
  end

  def validate_active_coupons_on_update
    merchant = Merchant.find(self.merchant_id)
    if self.status == "disabled"
      true
    else
      self.errors.add(:base, "Max Number of Active Coupons Reached: 5") if merchant.coupons.where("status = 0").size >= 5
    end
  end

  def number_of_successful_transactions
    transactions.where("result != 0").size
  end

end