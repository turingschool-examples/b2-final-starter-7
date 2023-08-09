# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Rake::Task["csv_load:all"].invoke

@merchant = Merchant.first

@discount1 = @merchant.discounts.create!(percent_discount: 10, threshold_quantity: 5)
@discount2 = @merchant.discounts.create!(percent_discount: 15, threshold_quantity: 9)
@discount3 = @merchant.discounts.create!(percent_discount: 40, threshold_quantity: 10)
@discount4 = @merchant.discounts.create!(percent_discount: 70, threshold_quantity: 15)