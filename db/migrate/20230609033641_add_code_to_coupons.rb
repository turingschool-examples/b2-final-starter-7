class AddCodeToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :code, :string
  end
end
