class Coupon < ApplicationRecord
  validates_presence_of :code,
                        :name,
                        :kind,
                        :merchant_id

  belongs_to :merchant
  has_many :invoices
  enum status: [:deactivated, :activated]
  enum kind: [:perc, :dollar]

end