class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def new 
  end

  def create
    @merchant = Merchant.find(params[:id]) 
    @coupon = Coupon.new(coupon_params)
    @coupon.merchant_id = @merchant.id
    if @merchant.coupons.where(status:1).count >= 5
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: Too many coupons"
    elsif @merchant.coupon_valid?(@coupon) == true && @coupon.save
      redirect_to "/merchants/#{@merchant.id}/coupons"
    else
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: Valid data must be entered"
    end
  end

  def show 
    @coupon = Coupon.find(params[:id])
  end

  private
  def coupon_params
    params.permit(:name, :discount, :code, :percent_dollar)
  end
end