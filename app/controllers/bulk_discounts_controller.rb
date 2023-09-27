class BulkDiscountsController < ApplicationController
  def index
    @bulk_discounts = BulkDiscount.all
    @merchant = Merchant.find(params[:id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
   @merchant = Merchant.find(params[:id])
   
  end

  def create

  end

end