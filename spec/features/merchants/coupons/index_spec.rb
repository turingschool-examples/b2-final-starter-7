require "rails_helper"

RSpec.describe "merchant coupon index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon_1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
    @coupon_2 = @merchant1.coupons.create!(name: "$10", unique_code: "TENHC", discount_amount: 100, discount_type: 0, status: 0)
    @coupon_3 = @merchant1.coupons.create!(name: "$1,000,000", unique_code: "MILLIONHC", discount_amount: 1_000_000, discount_type: 0, status: 0)
    @coupon_4 = @merchant1.coupons.create!(name: "5%", unique_code: "FIVEPRCHC", discount_amount: 5, discount_type: 1, status: 0)
    @coupon_5 = @merchant1.coupons.create!(name: "10%", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)

    @merchant2 = Merchant.create!(name: "Nail Care")

    @coupon_6 = @merchant2.coupons.create!(name: "Fiver", unique_code: "FIVENC", discount_amount: 5, discount_type: 0, status: 0)
    @coupon_7 = @merchant2.coupons.create!(name: "Tenner", unique_code: "TENNC", discount_amount: 100, discount_type: 0, status: 0)
    @coupon_8 = @merchant2.coupons.create!(name: "Millionaire", unique_code: "MILLIONNC", discount_amount: 1_000_000, discount_type: 0, status: 0)
    @coupon_9 = @merchant2.coupons.create!(name: "Five Percent", unique_code: "FIVEPRCNC", discount_amount: 5, discount_type: 1, status: 0)
    @coupon_10 = @merchant2.coupons.create!(name: "Ten Percent", unique_code: "TENPRCNC", discount_amount: 10, discount_type: 1, status: 0)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    visit merchant_coupons_path(@merchant1)
  end

  it "shows the merchant's coupons" do
    expect(page).to have_content("#{@merchant1.name}'s Coupons")

    within "##{@merchant1.id}-coupons" do
      expect(page).to have_content("Coupon Name: #{@coupon_1.name} | Discount Amount: $#{@coupon_1.discount_amount} off")
      expect(page).to have_content("Coupon Name: #{@coupon_2.name} | Discount Amount: $#{@coupon_2.discount_amount} off")
      expect(page).to have_content("Coupon Name: #{@coupon_3.name} | Discount Amount: $1,000,000 off")
      expect(page).to have_content("Coupon Name: #{@coupon_4.name} | Discount Amount: 5% off")
      expect(page).to have_content("Coupon Name: #{@coupon_5.name} | Discount Amount: 10% off")
      # Could refactor later to include spec helper to utilize view-helpers...
      # module ViewHelpers
      #   def h
      #     ViewHelper.instance
      #   end

      #   class ViewHelper
      #     include Singleton
      #     include ActionView::Helpers::NumberHelper
      #     include ApplicationHelper
      #   end
      # end

      # RSpec.configure do |config|
      #   config.include ViewHelpers
      # end
      # xample_spec.rb
      # require 'rails_helper'

      # feature 'some feature' do
      #   scenario 'can see the percentage' do
      #     savings = # Use rails view helpers freely in spec!
      #       h.number_to_percentage(3.00, strip_insignificant_zeros: true)
      #     expect(savings).to eq "3%"
      #   end
      # end
      expect(page).to_not have_content("Coupon Name: #{@coupon_6.name} | Discount Amount: $#{@coupon_6.discount_amount} off")
    end
  end
end
