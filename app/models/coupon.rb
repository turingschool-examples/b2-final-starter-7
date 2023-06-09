class Coupon < ApplicationRecord
  validates_presence_of :name, :discount, :code, :percent_dollar, :status, presence: true
  validates :discount, numericality: { only_integer: true }
  # validates_presence_of :discount, presence: true, numericality: true
  
  belongs_to :merchant
  has_many :invoices
  enum status: {inactive: 0, active: 1}

  def num_uses
    invoices.joins(:transactions)
            .where(transactions: { result: 'success' })
            .count
  end
end