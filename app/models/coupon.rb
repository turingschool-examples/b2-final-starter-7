class Coupon < ApplicationRecord
  belongs_to :merchant
  belongs_to :invoice, optional: true
  validates :unique_code, uniqueness: true
end
