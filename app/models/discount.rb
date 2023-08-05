class Discount < ApplicationRecord
  belongs_to :merchant

  validates :percentage, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :threshold, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end