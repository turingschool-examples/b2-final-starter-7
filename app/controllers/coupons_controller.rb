class CouponsController < ApplicationController
  before_action :find_merchant, only: [:index]

  def index
    find_merchant
    @coupons = @merchant.coupons
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end