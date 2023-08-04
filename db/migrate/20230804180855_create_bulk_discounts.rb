class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :quantity_threshold
      t.float :percentage

      t.timestamps
    end
  end
end
