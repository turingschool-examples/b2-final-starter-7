class BulkDiscountsController < ApplicationController

  def index
    require 'pry'; binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end
end