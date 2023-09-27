class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.float :percentage
      t.integer :threshold
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
