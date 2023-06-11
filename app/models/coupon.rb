class Coupon < ApplicationRecord
  validates_presence_of :code,
                        :name,
                        :kind,
                        :merchant_id

  validates :code, uniqueness: true

  belongs_to :merchant
  has_many :invoices
  enum status: [:deactivated, :activated]
  enum kind: [:Percentage, :Dollar]

  def used_transactions
    self.invoices
    .joins(:transactions)
    .where("transactions.result = 1")
    .count
  end
end
