class AddKindColumnToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :kind, :integer
  end
end
