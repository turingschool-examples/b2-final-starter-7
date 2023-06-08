class Coupon < ApplicationRecord
  validates_presence_of :name, :discount, presence: true
  belongs_to :merchant
  has_many :invoices
end