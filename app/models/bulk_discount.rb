class BulkDiscount < ApplicationRecord
  validates_presence_of :name,
                        :percentage,
                        :quantity
  
  belongs_to :merchant

  def decimal_to_percentage
    "#{(percentage * 100).to_i}%"
  end
end
