class CouponsController < ApplicationController
  before_action :find_coupon, only: [:show]
  before_action :find_merchant, only: [:index, :create, :new]

  def index
  end

  def show
  end

  def new
  end

  def create
    Coupon.create!(name: coupons_params[:name], unique_code: coupons_params[:unique_code], 
      status: coupons_params[:status], merchant: @merchant, discount: coupons_params[:discount], 
      discount_type: coupons_params[:discount_type])
  end

  private
  def coupons_params
    params.permit(:unique_code, :name, :status, :merchant_id, :discount, :discount_type)
  end

  def find_coupon_and_merchant 
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
  end
  
  def find_coupon
    @coupon = Coupon.find(params[:id])
  end
  
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end