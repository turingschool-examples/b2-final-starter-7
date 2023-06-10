class CouponsController < ApplicationController
  before_action :find_merchant, only: [:index]

  def index
    find_merchant
    @coupons = @merchant.coupons
  end

  def show
    find_merchant
    @coupon = Coupon.find(params[:id])
  end

  def new
    find_merchant
  end

  def create
    find_merchant
    coupon_to_create = Coupon.new(coupon_params)
    ## REFACTOR to live in validations with custom validation?
    # >>>>>>>>>>>>>>
    if @merchant.active_coupon_protection?
      redirect_to new_merchant_coupon_path(@merchant)
      flash[:alert] = "Error: Too Many Active Coupons"
    # <<<<<<<<<<<<<<
    elsif coupon_to_create.save
      redirect_to merchant_coupons_path(@merchant)
    else
      redirect_to new_merchant_coupon_path(@merchant)
      flash[:alert] = "Error: #{error_message(coupon_to_create.errors)}"
    end
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def coupon_params
    params.permit(:name, :unique_code, :discount_amount, :discount_type, :merchant_id)
  end
end