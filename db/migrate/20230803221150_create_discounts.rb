class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.integer :percentage, null: false
      t.integer :threshold, null: false
      t.references :merchant, foreign_key: true, null: false

      t.timestamps
    end
  end
end
