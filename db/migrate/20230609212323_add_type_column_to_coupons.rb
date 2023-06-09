class AddTypeColumnToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :type, :integer
  end
end
