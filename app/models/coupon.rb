class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  validates :unique_code, uniqueness: true
  enum status: ['Inactive', 'Active']
  enum discount_type: ["Percentage", "Dollar Amount"]

  def times_used
    invoices.joins(:transactions).where("result = 1").count
  end
end
