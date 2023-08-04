class AddMerchantsToBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :bulk_discounts, :merchants, null: false, foreign_key: true
  end
end
