class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.integer :percent_discount
      t.integer :threshold_quantity
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
