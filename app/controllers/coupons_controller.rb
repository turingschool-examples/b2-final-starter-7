class CouponsController < ApplicationController
  before_action :find_merchant#, only: [:index, :new, :edit, :show]

  def index
    @coupons = @merchant.coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new; end

  def create
    coupon_to_create = Coupon.new(coupon_params)
    if @merchant.active_coupon_protection?
      redirect_to new_merchant_coupon_path(@merchant)
      ## REFACTOR with base error message, this would be more applicable if the merchant could manually choose the status,
      ## but since it defaults to 0 it is somewhat moot
      # flash[:alert] = "Error: #{error_message(coupon_to_create.errors)}"
      # flash[:error] = "Error: #{coupon_to_create.errors.full_messages.to_sentence}"
      flash[:alert] = "Error: Max Number of Active Coupons Reached: 5"
    elsif coupon_to_create.save
      redirect_to merchant_coupons_path(@merchant)
    else
      redirect_to new_merchant_coupon_path(@merchant)
      flash[:alert] = "Error: #{error_message(coupon_to_create.errors)}"
      # flash[:alert] = "Error: Max Number of Active Coupons Reached: 5"
    end
  end

  def update
    coupon_to_update = Coupon.find(params[:id])
    ## Refactor later with @merchant.active_coupon_protection? or separate helper method
    if params[:commit] == "Deactivate Coupon"
      coupon_to_update.update(status: 1)
      # Potential Helper Method >>>>>
      if coupon_to_update.save
        redirect_to merchant_coupon_path(@merchant, coupon_to_update)
      else
        redirect_to merchant_coupon_path(@merchant, coupon_to_update)
        flash[:alert] = "Error: #{error_message(coupon_to_update.errors)}"
      end
      # Potential Helper Method <<<<<
    else
      coupon_to_update.update(status: 0)
      if coupon_to_update.save
        redirect_to merchant_coupon_path(@merchant, coupon_to_update)
      else
        redirect_to merchant_coupon_path(@merchant, coupon_to_update)
        flash[:alert] = "Error: #{error_message(coupon_to_update.errors)}"
      end
    end
  end

  def edit
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def coupon_params
    params.permit(:name, :unique_code, :discount_amount, :discount_type, :merchant_id)
    # params.require(:coupon).permit(:id, :name, :unique_code, :discount_amount, :discount_type, :merchant_id)
  end
end