class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :discount,
                        :status
                      
  belongs_to :merchant 
  has_many :invoices

end