require "rails_helper"

RSpec.describe "merchant coupon show", type: :feature do
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

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_1.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon_6.id)
    @invoice_4 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon_6.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant2.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant2.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 2)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 2)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_1.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_2.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_2.id)
  end

  context "merchant 2" do
    it "shows the merchant's coupon's attributes and how many times the coupon was used" do
      visit merchant_coupon_path(@merchant2, @coupon_6)

      expect(page).to have_content("Coupon Name: #{@coupon_6.name}")
      expect(page).to_not have_content("Coupon Name: #{@coupon_1.name}")
      expect(page).to have_content("Coupon Unique Code: #{@coupon_6.unique_code}")
      expect(page).to have_content("Discount Amount: $5 off")
      expect(page).to have_content("Discount Type: #{@coupon_6.discount_type}")
      expect(page).to have_content("Status: #{@coupon_6.status}")
      expect(page).to have_content("Coupon Used: #{@coupon_6.number_of_successful_transactions} times")
    end

    it "has a button to deactivate a coupon" do
      visit merchant_coupon_path(@merchant2, @coupon_6)

      click_on("Deactivate Coupon")
      expect(current_path).to eq(merchant_coupon_path(@merchant2, @coupon_6))

      @coupon_6.reload
      expect(@coupon_6.status).to eq("disabled")
    end
  end

  context "merchant 1" do
    it "shows the merchant's coupon's attributes and how many times the coupon was used" do
      visit merchant_coupon_path(@merchant1, @coupon_1)

      expect(page).to have_content("Coupon Name: #{@coupon_1.name}")
      expect(page).to_not have_content("Coupon Name: #{@coupon_6.name}")
      expect(page).to have_content("Coupon Unique Code: #{@coupon_1.unique_code}")
      expect(page).to have_content("Discount Amount: $5 off")
      expect(page).to have_content("Discount Type: #{@coupon_1.discount_type}")
      expect(page).to have_content("Status: #{@coupon_1.status}")
      expect(page).to have_content("Coupon Used: #{@coupon_1.number_of_successful_transactions} times")
    end
  end

end
