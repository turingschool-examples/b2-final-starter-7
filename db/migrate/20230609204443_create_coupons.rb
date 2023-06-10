class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.integer :status
      t.string :code
      t.integer :perc_disc
      t.integer :dollar_disc
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
