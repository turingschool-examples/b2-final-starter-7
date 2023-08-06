class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def eligible_discount
    item.merchant.bulk_discounts
    .where('bulk_discounts.quantity_threshold <= ?', self.quantity)
    .order("bulk_discounts.percentage_discount DESC")
    .limit(1)
    .first
  end

  def original_price
    unit_price * quantity
  end

  def final_price
    if eligible_discount
      original_price * eligible_discount.multiplier
    else
      original_price
    end
  end
end





# ACTIVE RECORD WIP

# QUESTION:  can not use AR method where on a single record, so what do i use?
#
# def final_price
#   where_not('eligible_discount = ?', nil)
#   .select('original_price * eligible_discount.multiplier AS deal')
#   .first.deal
# end
