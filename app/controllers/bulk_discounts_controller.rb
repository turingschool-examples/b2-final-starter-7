class BulkDiscountsController < ApplicationController
  before_action :find_invoice_and_merchant, only: [:show, :update]
  # before_action :find_merchant, only: [:index]

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def create
  end

  def delete
  end

  def edit
  end
end
