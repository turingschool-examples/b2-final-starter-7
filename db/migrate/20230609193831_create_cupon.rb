class CreateCupon < ActiveRecord::Migration[7.0]
  def change
    create_table :cupons do |t|
      t.integer :status
      t.string :code
      t.string :name
      t.integer :percent_discount
      t.integer :dollar_discount
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
