require "rails_helper"

RSpec.describe "coupons index" do
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
    @coupon2 = Coupon.create!(name: "Ten Dollars Off", discount: 10, code: "10123456789", percent_dollar: "dollar", merchant: @merchant1)
    @coupon3 = Coupon.create!(name: "One Dollar Off", discount: 1, code: "1123456789", percent_dollar: "dollar", status: 0, merchant: @merchant1)
    @coupon4 = Coupon.create!(name: "Twenty Dollars Off", discount: 20, code: "20123456789",percent_dollar: "dollar", merchant: @merchant2)
    @coupon5 = Coupon.create!(name: "Six Dollars Off", discount: 6, code: "6123456789", percent_dollar: "dollar", status: 0, merchant: @merchant1)
    @coupon6 = Coupon.create!(name: "Eight Dollars Off", discount: 8, code: "8123456789", percent_dollar: "dollar", merchant: @merchant1)
    @coupon7 = Coupon.create!(name: "Twenty Percent Off", discount: 20, code: "20987654321", percent_dollar: "percent", status: 0, merchant: @merchant1)
    @coupon8 = Coupon.create!(name: "Eleven Dollars Off", discount: 11, code: "11123456789", percent_dollar: "dollar", merchant: @merchant1)
    @coupon9 = Coupon.create!(name: "Eleven Percent Off", discount: 11, code: "11987654321", percent_dollar: "percent", status: 0, merchant: @merchant1)

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

    visit "/merchants/#{@merchant1.id}/coupons"
  end

  # 1. Merchant Coupons Index 
  it "displays my coupon names, amount off, and links to each coupon show page" do
    expect(page).to have_content(@coupon1.name)
    expect(page).to have_content(@coupon2.name)
    expect(page).to have_content(@coupon3.name)
    expect(page).to have_content("Amount Off: $#{@coupon1.discount}")
    expect(page).to have_content("Amount Off: $#{@coupon2.discount}")
    expect(page).to have_content("Amount Off: $#{@coupon3.discount}")
    expect(page).to have_link("Show #{@coupon1.name}")
    expect(page).to have_link("Show #{@coupon2.name}")
    expect(page).to have_link("Show #{@coupon3.name}")
    expect(page).to_not have_content(@coupon4.name)
  end
  # 2. Merchant Coupon Create 
  it "can create new coupons" do
    expect(page).to_not have_content("Seven Dollars Off")
    expect(page).to have_link("Create New Coupon")
    click_link("Create New Coupon")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
    expect(page).to have_field("name")
    expect(page).to have_field("code")
    expect(page).to have_field("discount")
    expect(page).to have_field("percent_dollar")

    fill_in "name", with: "Seven Dollars Off"
    fill_in "code", with: "7123456789"
    fill_in "discount", with: "7"
    select "dollar", from: "percent_dollar"
    click_button "Submit"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons")
    expect(page).to have_content("Seven Dollars Off")
  end
  # 2b. Sad Path Testing - valid data input
  it "validates form data input" do
  # code is not unique
    click_link("Create New Coupon")
    fill_in "name", with: "Seven Dollars Off"
    fill_in "code", with: "5123456789"
    fill_in "discount", with: "7"
    select "dollar", from: "percent_dollar"
    click_button "Submit"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
    expect(page).to have_content("Error: Valid data must be entered")
  # discount is not an integer
    fill_in "name", with: "Seven Dollars Off"
    fill_in "code", with: "7123456789"
    fill_in "discount", with: "not_a_number"
    select "dollar", from: "percent_dollar"
    click_button "Submit"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
    expect(page).to have_content("Error: Valid data must be entered")
  # did not select $ or % 
    fill_in "name", with: "Seven Dollars Off"
    fill_in "code", with: "7123456789"
    fill_in "discount", with: "7"
    click_button "Submit"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
    expect(page).to have_content("Error: Valid data must be entered")
  end
  # 2c. Sad Path Testing - only 5 active coupons allowed
  it "does not allow more than 5 active coupons per merchant" do
    @coupon10 = Coupon.create!(name: "Fifty Percent Off", discount: 50, code: "50123456789", percent_dollar: "percent", merchant: @merchant1)

    click_link("Create New Coupon")
    fill_in "name", with: "Seven Dollars Off"
    fill_in "code", with: "7123456789"
    fill_in "discount", with: "7"
    select "dollar", from: "percent_dollar"
    click_button "Submit"
    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
    expect(page).to have_content("Error: Too many active coupons")
  end
# 6. Merchant Coupon Index Sorted
  it "does sorts coupons by status" do
    within "#active" do
      expect(page).to have_content("#{@coupon1.name}")
      expect(page).to have_content("#{@coupon2.name}")
      expect(page).to have_content("#{@coupon6.name}")
      expect(page).to have_content("#{@coupon8.name}")
    end
    
    within "#inactive" do
      expect(page).to have_content("#{@coupon3.name}")
      expect(page).to have_content("#{@coupon5.name}")
      expect(page).to have_content("#{@coupon7.name}")
      expect(page).to have_content("#{@coupon9.name}")
    end

    expect(page).to_not have_content("#{@coupon4.name}")
  end
# 9: Holidays API
  it "lists the next 3 US holidays" do 
    holidays = HolidayService.new.get_holidays
    expect(page).to have_content("Upcoming Holidays")

    within "#upcoming_holidays" do
      expect(page).to have_content("Juneteenth")
      expect(page).to have_content("2023-06-19")
      expect(page).to have_content("Independence Day")
      expect(page).to have_content("2023-07-04")
      expect(page).to have_content("Labour Day")
      expect(page).to have_content("2023-09-04")

      expect(page).to have_content(holidays[0][:name])
      expect(page).to have_content(holidays[0][:date])
      expect(page).to have_content(holidays[1][:name])
      expect(page).to have_content(holidays[1][:date])
      expect(page).to have_content(holidays[2][:name])
      expect(page).to have_content(holidays[2][:date])
    end
  end
end
