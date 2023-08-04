class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  def new
    @discount = Discount.new
    @merchant = Merchant.find(params[:merchant_id])
  end
  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Bulk discount was successfully created."
      redirect_to merchant_discounts_path
    else
      flash[:alert] = "Invalid information, please try again."
      render :new
    end
  end

  private
  def discount_params
    params.require(:discount).permit(:percentage, :threshold)
  end
  
end