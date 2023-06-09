class Cupon < ApplicationRecord
  validates_presence_of :status,
                        :code,
                        :name,
                        :percent_discount,
                        :dollar_discount
  belongs_to :merchant
  has_many :invoices
  enum status: [:activated, :deactivated]
end