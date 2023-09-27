class DiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    @merchant = Merchant.find(params[:merchant_id])
    float = params[:percentage].to_f
    Discount.create!(percentage: float,
      threshold: params[:threshold],
      merchant: @merchant)
      redirect_to merchant_discounts_path(@merchant)
  end

end