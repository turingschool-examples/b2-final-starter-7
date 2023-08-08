class DiscountsController < ApplicationController
  before_action :find_merchant_and_discount, only: [:show]
  before_action :find_merchant, only: [:index, :new, :create]

  #this helps dry right?

  def index
  end

  def show
  end

  def new
    @discount = Discount.new
  end

  def create
    discount = Discount.new(discount_params)
    if discount.save
      redirect_to merchant_discounts_path(@merchant)
      flash[:success] = "Discount Successfully Added!" 
    else
      flash[:danger] = "Discount Not created: Required information missing"
      render :new
    end
  end

private

  def discount_params
    params.require(:discount).permit(:percent_discount, :threshold_quantity, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant_and_discount
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end
end