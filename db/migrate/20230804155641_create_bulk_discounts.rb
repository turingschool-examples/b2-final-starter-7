class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, null: false, foreign_key: true
      t.integer :percentage_discount
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end