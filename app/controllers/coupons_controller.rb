class CouponsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index, :show, :edit, :get, :update]
  before_action :find_coupon, only: [:show, :edit, :get, :update]

  def index
  end

  def show
  end

  def new
  end

  def update
    if @coupon.status == "activated" && @coupon.pending_invoices?
      redirect_to merchant_coupon_path(@merchant, @coupon)
      flash.notice = "Cannot Deactivate. Coupon on Active Invoice."
    elsif @coupon.activated?
      @coupon.deactivated!
      redirect_to merchant_coupon_path(@merchant, @coupon)
    else
      @coupon.activated!
      redirect_to merchant_coupon_path(@merchant, @coupon)
    end
  end

  def create
    coupon = Coupon.new(name: params[:name],
                        code: params[:code],
                        status: params[:status],
                        perc_disc: params[:perc_disc],
                        dollar_disc: params[:dollar_disc],
                        kind: params[:kind],
                        merchant: @merchant)
    if @merchant.max_activated_coupons
      redirect_to new_merchant_coupon_path(@merchant)
      flash.notice = "Too Many Active Coupons. Set Status to 'deactivated.'"
    elsif coupon.save
      redirect_to merchant_coupons_path(@merchant)
    elsif
      redirect_to new_merchant_coupon_path(@merchant)
      flash.notice = "Coupon name not unique."
    end
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_coupon
    @coupon = Coupon.find(params[:id])
  end

  private
  def coupon_params
    params.permit(:coupon, :id, :name, :code, :perc_disc, :dollar_disc, :kind)
  end
end
