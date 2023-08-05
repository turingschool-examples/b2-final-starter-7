class  BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = BulkDiscount.all
  end
  
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(new_bulk_discount_params)
    if @bulk_discount.save
      flash.notice = "New Discount Successfully Created!"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.notice = "Please complete all fields to continue."
      render :new
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy
    flash.notice = "Your Discount Has Been Deleted"
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def new_bulk_discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end
