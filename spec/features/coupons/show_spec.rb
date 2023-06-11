require "rails_helper"

describe "merchant coupon show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @coupon1 = Coupon.create!(status: 1, code: "20off", name: "20 perc off", perc_disc: 20, dollar_disc: 0, kind: 0, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(status: 1, code: "10off", name: "10 dollers off", perc_disc: 0, dollar_disc: 10, kind: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create!(status: 1, code: "15off", name: "15 dollers off", perc_disc: 0, dollar_disc: 15, kind: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create!(status: 1, code: "25off", name: "25 dollers off", perc_disc: 0, dollar_disc: 25, kind: 1, merchant_id: @merchant1.id)
    @coupon5 = Coupon.create!(status: 0, code: "35off", name: "35 dollers off", perc_disc: 0, dollar_disc: 35, kind: 1, merchant_id: @merchant2.id)

    @coupon6 = Coupon.create!(status: 1, code: "100off", name: "100 dollers off", perc_disc: 0, dollar_disc: 100, kind: 1, merchant_id: @merchant2.id)

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

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 1, coupon_id: @coupon3.id, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id, created_at: "2012-03-28 14:54:09")

    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, coupon_id: @coupon1.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, coupon_id: @coupon1.id, status: 1)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, coupon_id: @coupon2.id, status: 2) #invoice status 0 cancelled 1 in progress 2 completed

    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0) #invoice item status 0pending 1packaged 2shipped
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id) #transaction result 0failed 1 success
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 0, invoice_id: @invoice_2.id)#
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)#
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)#
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)#
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)

    visit merchant_coupon_path(@merchant1, @coupon1)
  end

  it "shows name of code" do
    expect(page).to have_content(@coupon1.name)
  end

  it "shows the percent/dollar off value" do
    expect(page).to have_content(@coupon1.perc_disc)
  end

  it "shows status (active or inactive)" do
    expect(page).to have_content(@coupon1.status)
  end

  #sad path test
  it "shows how many times the coupon has been used" do
    #below shows successfull transactions cupon was used on (2)
    expect(page).to have_content("Number of Uses: #{@coupon1.used_transactions}")
    #below shows how many total transactions this coupon is on (3) but one was failed
    expect(page).to_not have_content("Number of Uses: #{@coupon1.invoices.joins(:transactions).count}")

  end
    # * Sad Paths to consider:
    # 1. A coupon cannot be deactivated if there are any pending invoices with that coupon.
  it "see a button to deactivate coupon" do
    expect(page).to have_button("Deactivate")
  end

  it "when button to deactivate is clicked I am taken back to coupon show page and status is 'deactivated'" do
    visit merchant_coupon_path(@merchant1, @coupon2)
    expect(page).to have_content("Status: activated")
    click_button "Deactivate"
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon2))
    expect(page).to have_content("Status: deactivated")
    expect(page).to_not have_button("Deactivate")
  end

  #sad path test for deactivating coupon
  it "cannot deactivate a coupon if on an active invoice" do
    visit merchant_coupon_path(@merchant1, @coupon3)
    expect(page).to have_content("Status: activated")
    click_button "Deactivate"
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon3))
    expect(page).to have_content("Cannot Deactivate. Coupon on Active Invoice.")
    expect(page).to have_content("Status: activated")
    expect(page).to have_button("Deactivate")
  end

  it "see a button to activate coupon" do
    visit merchant_coupon_path(@merchant1, @coupon5)
    expect(page).to have_button("Activate")
  end

  it "when button to activate is clicked I am taken back to coupon show page and status is 'activated'" do
    visit merchant_coupon_path(@merchant1, @coupon5)
    expect(page).to have_content("Status: deactivated")
    click_button "Activate"
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon5))
    expect(page).to have_content("Status: activated")
    expect(page).to_not have_button("Activate")
  end
end
