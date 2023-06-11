require "rails_helper"

RSpec.describe "coupon show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jolene's Joint")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @coupon1 = Coupon.create!(name: "Five Dollars Off", discount: 5, code: "5123456789", percent_dollar: "dollar", merchant: @merchant1)
    @coupon2 = Coupon.create!(name: "Ten Percent Off", discount: 10, code: "10987654321", percent_dollar: "percent", merchant: @merchant1)
    @coupon3 = Coupon.create!(name: "One Dollar Off", discount: 1, code: "1123456789", percent_dollar: "dollar", merchant: @merchant1)
    @coupon4 = Coupon.create!(name: "Twenty Dollars Off", discount: 20, code: "20123456789", percent_dollar: "dollar", merchant: @merchant2)
    @coupon5 = Coupon.create!(name: "Twenty Percent Off", discount: 20, code: "20987654321", percent_dollar: "percent", status: 0, merchant: @merchant1)

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon2.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon1.id)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @coupon1.id)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, coupon_id: @coupon2.id)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

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
    @transaction8 = Transaction.create!(credit_card_number: 203942, result: 0, invoice_id: @invoice_1.id)

    visit "/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"

  end
# 3. Merchant Coupon Show Page - Dollar 
  it "displays a coupon's attributes" do 
    expect(page).to have_content("Name: #{@coupon1.name}")
    expect(page).to have_content("Code: #{@coupon1.code}")
    expect(page).to have_content("Discount: $#{@coupon1.discount}")
    expect(page).to have_content("Status: #{@coupon1.status}")
    expect(page).to have_content("Times Used: 3")

    expect(page).to_not have_content("Name: #{@coupon2.name}")
    expect(page).to_not have_content("Code: #{@coupon3.code}")
    expect(page).to_not have_content("Name: #{@coupon4.name}")
  end
# 3. Merchant Coupon Show Page - Percent 
  it "displays a coupon's attributes" do 
    visit "/merchants/#{@merchant1.id}/coupons/#{@coupon2.id}"
    expect(page).to have_content("Name: #{@coupon2.name}")
    expect(page).to have_content("Code: #{@coupon2.code}")
    expect(page).to have_content("Discount: #{@coupon2.discount}%")
    expect(page).to have_content("Status: #{@coupon2.status}")
    expect(page).to have_content("Times Used: 2")
  end
# 4. Merchant Coupon Deactivate
  it "can deactivate coupons" do 
    expect(page).to have_content("Status: active")
    expect(page).to have_button("Deactivate")
    click_button "Deactivate"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}")
    expect(page).to have_content("Status: inactive")
  end
# 4b. Sad Path: A coupon cannot be deactivated if there are any in progress invoices with that coupon
  it "cannot deactivate coupons on invoices in progress" do 
    @invoice_8 = Invoice.create!(customer_id: @customer_1.id, status: 1, coupon_id: @coupon1.id)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 3, unit_price: 5, status: 1)
    @transaction9 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    
    expect(page).to have_content("Status: active")
    expect(page).to have_button("Deactivate")
    click_button "Deactivate"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}")
    expect(page).to have_content("Status: active")
    expect(page).to have_content("Error: Cannot deactive coupons with invoices in progress")
  end
# 5. Merchant Coupon Activate
  it "can deactivate coupons" do 
    visit "/merchants/#{@merchant1.id}/coupons/#{@coupon5.id}"
    expect(page).to have_content("Status: inactive")
    expect(page).to have_button("Activate")
    click_button "Activate"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon5.id}")
    expect(page).to have_content("Status: active")
  end
# 5b. Sad Path: Merchant Coupon cannot be activated if merchant already has 5 active coupons 
  it "cannot activate a coupon if the merchant already has 5 active coupons" do 
    @coupon6 = Coupon.create!(name: "Eleven Percent Off", discount: 11, code: "11987654321", percent_dollar: "percent", merchant: @merchant1)
    @coupon7 = Coupon.create!(name: "Eleven Dollars Off", discount: 11, code: "11123456789", percent_dollar: "dollar", merchant: @merchant1)
    
    visit "/merchants/#{@merchant1.id}/coupons/#{@coupon5.id}"

    expect(page).to have_content("Status: inactive")
    expect(page).to have_button("Activate")
    click_button "Activate"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon5.id}")
    expect(page).to have_content("Error: Too many active coupons")
    expect(page).to have_content("Status: inactive")
  end
end