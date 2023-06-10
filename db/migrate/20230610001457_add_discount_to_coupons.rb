class AddDiscountToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :discount, :float
    add_column :coupons, :discount_type, :integer
  end
end
