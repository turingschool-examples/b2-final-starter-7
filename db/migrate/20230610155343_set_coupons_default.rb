class SetCouponsDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :coupons, :status, :integer, default: 0
    change_column :coupons, :perc_disc, :integer, default: 0
    change_column :coupons, :dollar_disc, :integer, default: 0
  end
end
