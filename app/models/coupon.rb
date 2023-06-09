class Coupon < ApplicationRecord
  validates_presence_of :status,
                        :code,
                        :name,
                        :percent_disc,
                        :dollar_disc
  belongs_to :merchant
  has_many :invoices
  enum status: [:activated, :deactivated]
end