class AddPercentDollarToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :percent_dollar, :string
  end
end
