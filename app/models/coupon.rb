class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :percent_off
                      
  belongs_to :merchant 
  has_many :invoices

end