class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :percent_dollar, :status, presence: true
  validates_presence_of :discount, presence: true, numericality: true
  
  belongs_to :merchant
  has_many :invoices
  enum status: {inactive: 0, active: 1}
end