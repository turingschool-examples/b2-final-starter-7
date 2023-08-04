class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @merchant = Merchant.find(params[:merchant_id]) # Required for the pre-build header to function correctly
    @discount = @merchant.discounts.find(params[:id])
    
  end

  def new
    @discount = Discount.new
    @merchant = Merchant.find(params[:merchant_id]) # Required for the pre-build header to function correctly
  end

  def create
    @merchant = Merchant.find(params[:merchant_id]) # Required for the pre-build header to function correctly
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Bulk discount was successfully created."
      redirect_to merchant_discounts_path
    else
      flash[:alert] = "Invalid information, please try again."
      render :new
    end
  end
  
  def edit
    @merchant = Merchant.find(params[:merchant_id]) # Required for the pre-build header to function correctly
    @discount = @merchant.discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
    if @discount.update(discount_params)
      flash.notice = "Bulk discount updated"
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash.notice = "Invalid information.  Please try again."
      render :edit
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id]) # Required for the pre-build header to function correctly
    discount = @merchant.discounts.find(params[:id])
    discount.destroy
    redirect_to merchant_discounts_path(@merchant), notice: "Discount was successfully deleted."
  end

  private
  def discount_params
    params.require(:discount).permit(:percentage, :threshold)
  end
  
end