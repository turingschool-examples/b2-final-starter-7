class BulkDiscount < ApplicationRecord
  validates_presence_of :name,
                        :percentage,
                        :quantity

  validates :percentage, numericality: { greater_than: 0, less_than: 1.0 }
  
  belongs_to :merchant
  belongs_to :invoice_item, optional: true

  def decimal_to_percentage
    "#{(percentage * 100).round}%"
  end
end
