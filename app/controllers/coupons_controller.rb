class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @coupon = Coupon.find(params[:id])
  end
end