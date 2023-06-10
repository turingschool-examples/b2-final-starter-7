class RemoveDiscountColumFromCoupons < ActiveRecord::Migration[7.0]
  def change
    remove_column :coupons, :dollar_discount, :integer
  end
end
