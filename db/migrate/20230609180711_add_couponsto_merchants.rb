class AddCouponstoMerchants < ActiveRecord::Migration[7.0]
  def change
    add_reference :coupons, :merchant, foreign_key: true

  end
end
