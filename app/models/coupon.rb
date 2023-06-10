class Coupon < ApplicationRecord
  validates_presence_of :status, #made default status 0
                        :code,
                        :name,
                        :perc_disc, #make default value 0
                        :dollar_disc, #make default value 0
                        :kind
                        :merchant_id

  belongs_to :merchant
  has_many :invoices
  enum status: [:deactivated, :activated]
  enum kind: [:perc, :dollar]

end