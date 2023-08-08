class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant

  validates_presence_of :percent_discount
  validates_presence_of :threshold_quantity
end