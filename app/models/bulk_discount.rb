class BulkDiscount < ApplicationRecord
  validates_presence_of :merchant_id,
                        :percentage_discount,
                        :quantity_threshold

  belongs_to :merchant

  def multiplier
    (1 - (percentage_discount/100.00)).to_f
  end
end