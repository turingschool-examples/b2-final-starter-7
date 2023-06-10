class Coupon < ApplicationRecord
  belongs_to :merchant
  belongs_to :invoice, optional: true
  validates :unique_code, uniqueness: true
  enum status: [:disabled, :enabled]
  enum discount_type: ["Percentage", "Dollar Amount"]
end
