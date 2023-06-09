class Coupon < ApplicationRecord
  validates_presence_of :name, presence: true
  validates_presence_of :discount, presence: true, numericality: true
  validates_presence_of :code, presence: true
  
  belongs_to :merchant
  has_many :invoices
end