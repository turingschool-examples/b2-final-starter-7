class BulkDiscount < ApplicationRecord
  validates_presence_of :merchant_id,
                        :percentage_discount,
                        :quantity_threshold

  belongs_to :merchant
end