# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke
@bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: 1)
@bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percent_discount: 30, merchant_id: 1)
