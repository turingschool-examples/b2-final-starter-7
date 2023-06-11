require "rails_helper"

RSpec.describe "invoices show" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @coupon1 = Coupon.create!(name: "Five Dollars Off", discount: 5, code: "5123456789", percent_dollar: "dollar", merchant: @merchant1)
    @coupon2 = Coupon.create!(name: "Five Percent Off", discount: 5, code: "5987654321", percent_dollar: "percent", merchant: @merchant1)

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)
    @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1)
    @invoice_9 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_10 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon2.id)
    @invoice_11 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 12, unit_price: 6, status: 1)
    @ii_12 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_1.id, quantity: 12, unit_price: 6, status: 1)
    @ii_12 = InvoiceItem.create!(invoice_id: @invoice_10.id, item_id: @item_2.id, quantity: 10, unit_price: 5, status: 1)
    @ii_13 = InvoiceItem.create!(invoice_id: @invoice_11.id, item_id: @item_4.id, quantity: 2, unit_price: 2, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
    @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    @transaction9 = Transaction.create!(credit_card_number: 203943, result: 1, invoice_id: @invoice_9.id)
    @transaction10 = Transaction.create!(credit_card_number: 503943, result: 1, invoice_id: @invoice_10.id)

  end

  it "shows the invoice information" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_1.status)
    expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %-d, %Y"))
  end

  it "shows the customer information" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@customer_1.first_name)
    expect(page).to have_content(@customer_1.last_name)
    expect(page).to_not have_content(@customer_2.last_name)
  end

  it "shows the item information" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_1.unit_price)
    expect(page).to_not have_content(@ii_4.unit_price)

  end

  it "shows the total revenue for this invoice" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@invoice_1.total_revenue)
  end

  it "shows a select field to update the invoice status" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    within("#the-status-#{@ii_1.id}") do
      page.select("cancelled")
      click_button "Update Invoice"

      expect(page).to have_content("cancelled")
    end

    within("#current-invoice-status") do
      expect(page).to_not have_content("in progress")
    end
  end
# 7. Merchant Invoice Show Page: Subtotal and Grand Total Revenues - dollar amount off
  it "displays subtotal and grand total revenues with a dollar amount off coupon" do
    visit merchant_invoice_path(@merchant1, @invoice_9)

    expect(page).to have_content("Subtotal: $#{@invoice_9.total_revenue}")
    expect(page).to have_content("Grand Total Revenue: $#{@invoice_9.grand_total}")
    expect(page).to have_content("Coupon: #{@coupon1.name}")
    expect(page).to have_content("#{@coupon1.code}")
    expect(page).to have_link("#{@coupon1.name} #{@coupon1.code}")
  end
# 7b. Merchant Invoice Show Page: Subtotal and Grand Total Revenues - percentage off
  it "displays subtotal and grand total revenues with a percentage off coupon" do
    visit merchant_invoice_path(@merchant1, @invoice_10)

    expect(page).to have_content("Subtotal: $#{@invoice_10.total_revenue}")
    expect(page).to have_content("Grand Total Revenue: $#{@invoice_10.grand_total}")
    expect(page).to have_content("Coupon: #{@coupon2.name}")
    expect(page).to have_content("#{@coupon2.code}")
    expect(page).to have_link("#{@coupon2.name} #{@coupon2.code}")
  end
# 7c. Sad Path: Grand Total Revenues - should never be below $0
  it "will not display a grand total revenue less than $0" do 
    visit merchant_invoice_path(@merchant1, @invoice_11)
    
    expect(page).to have_content("Subtotal: $#{@invoice_11.total_revenue}")
    expect(page).to have_content("Grand Total Revenue: $0.00")
    expect(page).to have_content("Coupon: #{@coupon1.name}")
  end
end
