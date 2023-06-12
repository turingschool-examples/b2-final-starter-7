# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke

  @merchant = Merchant.create!(name: 'Jeremicah')
  @customer = Customer.create!(first_name: 'Alice', last_name: 'Walker', address: 'a string', city: 'a city', state: 'a state', zip: 78901 )
  @coupon = Coupon.create!(name: 'Labor Day', unique_code: '20OFF', discount: 20, discount_type: 0, merchant: @merchant)
  @invoice_1 = Invoice.create!(customer_id: @customer.id, status: 2, coupon: @coupon)
  @invoice_2 = Invoice.create!(customer_id: @customer.id, status: 2, coupon: @coupon)
  @invoice_3 = Invoice.create!(customer_id: @customer.id, status: 2, coupon: @coupon)
  @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
  @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
  @transaction3 = Transaction.create!(credit_card_number: 234092, result: 0, invoice_id: @invoice_3.id)