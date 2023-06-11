class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  validates :unique_code, uniqueness: true
  enum status: ['Inactive', 'Active']
  enum discount_type: ["Percentage", "Dollar Amount"]
end
