class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :unique_code
      t.integer :percent_off
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end