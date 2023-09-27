class Discount < ApplicationRecord
  validates_presence_of :percentage,
                        :threshold,
                        :merchant_id

  belongs_to :merchant
end