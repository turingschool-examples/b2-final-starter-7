class BulkDiscount < ApplicationRecord
  validates_presence_of :name,
                        :percentage,
                        :quantity
  
  belongs_to :merchant

  def percentage_to_decimal
    percentage / 100.0
  end
end
