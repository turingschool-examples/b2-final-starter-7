class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def revenue_discounted

    total = 0.0

    invoice_items.each do |item|

      cost = item.unit_price


      best_discount = bulk_discounts.where("quantity_threshold <= ?", item.quantity).order(percentage_discount: :desc).take

      #best_discount = bulk_discounts.where("quantity_threshold <= ?", item.quantity).order(percentage_discount: :desc).take.select("*, percentage_discount AS discount")

      if best_discount 
        cost -= (cost * (best_discount.percentage_discount / 100.0))
      end 
      
      total += cost * item.quantity
    end 
    total
  end

  def discount_finder


    invoice_items.select("invoice_items.*, (SELECT id FROM bulk_discounts WHERE quantity_threshold <= invoice_items.quantity ORDER BY percentage_discount DESC LIMIT 1) AS discount")

    # <% discount_finder.each do |discount_data| %>
    #   <div>
    #     Item: <%= discount_data[:item].name %>
    #     Best Discount: <%= discount_data[:discount] ? "#{discount_data[:discount].percentage_discount}% off" : "No discount available" %>
    #     <% if discount_data[:discount] %>
    #       <%= link_to "View Discount", discount_path(discount_data[:discount]) %>
    #     <% end %>
    #   </div>
    # <% end %>
    
    # discount_hash = {}

    # invoice_items.each do |item|

    #   best_discount = bulk_discounts.where("quantity_threshold <= ?", item.quantity).order(percentage_discount: :desc).take
    #   require 'pry'; binding.pry
    #   #discount_hash[:] = best_discount
    # end
    # discount_hash
  end
end


