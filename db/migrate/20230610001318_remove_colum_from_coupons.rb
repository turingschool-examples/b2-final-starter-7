class RemoveColumFromCoupons < ActiveRecord::Migration[7.0]
  def change
    remove_column :coupons, :percent_discount, :integer
  end
end
