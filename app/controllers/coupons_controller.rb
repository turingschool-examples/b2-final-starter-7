class CouponsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index]

  def index
  end

  def show
  end

  def new
  end

  def create
    Coupon.create!(name: params[:name],
                  code: params[:code],
                  perc_disc: params[:perc_disc],
                  dollar_disc: params[:dollar_disc],
                  kind: params[:kind],
                  merchant: @merchant)
    redirect_to merchant_coupons_path(@merchant)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end


private
def coupon_params
  params.require(:coupon).permit(:status)
end

end
