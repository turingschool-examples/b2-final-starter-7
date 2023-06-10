class AddColumnNameToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :name, :string
  end
end
