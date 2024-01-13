class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :coupon_code,
                        :discount_amount,
                        :discount_type,
                        :merchant_id

  belongs_to :merchant
  belongs_to :invoice, optional: true

  enum discount_type: [:dollar, :percent]
end
