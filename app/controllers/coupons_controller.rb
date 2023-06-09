class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def new 
  end

  def create
    merchant = Merchant.find(params[:id]) 
    @coupon = Coupon.new(coupon_params)
    @coupon.merchant_id = merchant.id
    if merchant.coupons.count < 5 && @coupon.save
      redirect_to "/merchants/#{merchant.id}/coupons"
    elsif merchant.coupons.count >= 5
      redirect_to "/merchants/#{merchant.id}/coupons/new"
      flash[:alert] = "Error: Too many coupons"
    else
      redirect_to "/merchants/#{merchant.id}/coupons/new"
      flash[:alert] = "Error: Valid data must be entered"
    end
  end

  private
  def coupon_params
    params.permit(:name, :discount, :code)
  end
end