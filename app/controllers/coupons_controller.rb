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
    if @merchant.coupon_count? == true
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: Too many coupons"
    elsif @merchant.coupon_valid?(@coupon.code) == true && @coupon.save
      redirect_to "/merchants/#{@merchant.id}/coupons/"
    else
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: Valid data must be entered"
    end
  end

  def show 
    @merchant = Merchant.find(params[:merchant_id]) 
    @coupon = Coupon.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant]) 
    @coupon = Coupon.find(params[:id])
    if params[:deactivate] == "true"
      @coupon.update(status: "inactive")
    elsif
      @coupon.update(status: "active")
    end
    @coupon.save
    redirect_to "/merchants/#{@merchant.id}/coupons/#{@coupon.id}"
  end

  private
  def coupon_params
    params.permit(:name, :discount, :code, :percent_dollar)
  end
end