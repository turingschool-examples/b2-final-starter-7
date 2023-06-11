require "rails_helper"

describe "Admin Invoices Show Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")
    
    @coupon1 = Coupon.create!(name: "Five Dollars Off", discount: 5, code: "5123456789", percent_dollar: "dollar", merchant: @m1)
    @coupon2 = Coupon.create!(name: "Five Percent Off", discount: 5, code: "5987654321", percent_dollar: "percent", merchant: @m1)
    @coupon3 = Coupon.create!(name: "Twenty Dollars Off", discount: 20, code: "20123456789", percent_dollar: "dollar", merchant: @m1)

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09")
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09")
    @i3 = Invoice.create!(customer_id: @c1.id, status: 2, coupon_id: @coupon1.id)
    @i4 = Invoice.create!(customer_id: @c1.id, status: 2, coupon_id: @coupon2.id)
    @i5 = Invoice.create!(customer_id: @c1.id, status: 2, coupon_id: @coupon3.id)

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)
    @item_3 = Item.create!(name: "nest", description: "nest nest nest", unit_price: 10, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)
    @ii_5 = InvoiceItem.create!(invoice_id: @i4.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)
    @ii_6 = InvoiceItem.create!(invoice_id: @i5.id, item_id: @item_3.id, quantity: 1, unit_price: 10, status: 2)

    visit admin_invoice_path(@i1)
  end

  it "should display the id, status and created_at" do
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it "should display the customers name and shipping address" do
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it "should display all the items on the invoice" do
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)

    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")

    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)

    expect(page).to_not have_content("87")
    # expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end

  it "should display the total revenue the invoice will generate" do
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it "should have status as a select field that updates the invoices status" do
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end
# 8. Admin Invoice Show Page: Subtotal and Grand Total Revenues - dollar amount off
  it "displays subtotal and grand total revenues and coupon info for a dollar amount off coupon" do
    visit admin_invoice_path(@i3)

    expect(page).to have_content("Subtotal: $1,044.00")
    expect(page).to have_content("Grand Total Revenue: $1,039.00")
    expect(page).to have_content("Coupon Name: #{@coupon1.name}")
    expect(page).to have_content("Coupon Code: #{@coupon1.code}")
  end
# 8b. Admin Invoice Show Page: Subtotal and Grand Total Revenues - percentage off
  it "displays subtotal and grand total revenues and coupon info for a percentage off coupon" do
    visit admin_invoice_path(@i4) 

    expect(page).to have_content("Subtotal: $1,044.00")
    expect(page).to have_content("Grand Total Revenue: $991.80")
    expect(page).to have_content("Coupon Name: #{@coupon2.name}")
    expect(page).to have_content("Coupon Code: #{@coupon2.code}")
  end
# 8c. Sad Path: Grand Total Revenues - should never be below $0
  it "will not display a grand total revenue less than $0" do
    visit admin_invoice_path(@i5) 

    expect(page).to have_content("Subtotal: $10.00")
    expect(page).to have_content("Grand Total Revenue: $0.00")
    expect(page).to have_content("Coupon Name: #{@coupon3.name}")
    expect(page).to have_content("Coupon Code: #{@coupon3.code}")
  end
end
