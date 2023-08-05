require "rails_helper"

describe "Bulk Discounts" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
    @discount1 = @m1.bulk_discounts.create!(name: "20 percent off", percentage: 20, quantity_threshold: 10 )
    @discount2 = @m1.bulk_discounts.create!(name: "10 percent off", percentage: 10, quantity_threshold: 5 )

    @c1 = Customer.create!(first_name: "Bilbo", last_name: "Baggins")
    @c2 = Customer.create!(first_name: "Frodo", last_name: "Baggins")
    @c3 = Customer.create!(first_name: "Samwise", last_name: "Gamgee")
    @c4 = Customer.create!(first_name: "Aragorn", last_name: "Elessar")
    @c5 = Customer.create!(first_name: "Arwen", last_name: "Undomiel")
    @c6 = Customer.create!(first_name: "Legolas", last_name: "Greenleaf")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
    @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
    @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
    @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
    @i5 = Invoice.create!(customer_id: @c4.id, status: 2)

    @t1 = Transaction.create!(invoice_id: @i1.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
    @t2 = Transaction.create!(invoice_id: @i2.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
    @t3 = Transaction.create!(invoice_id: @i3.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
    @t4 = Transaction.create!(invoice_id: @i4.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)
    @t5 = Transaction.create!(invoice_id: @i5.id, credit_card_number: 00000, credit_card_expiration_date: 00000, result: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @m1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)

  end

  #1: Merchant Bulk Discounts Index
  describe "As a merchant" do
    describe "When I visit my merchant dashboard" do
      describe "Then I see a link to view all my discounts" do
        describe "When I click this link" do
          describe "Then I am taken to my bulk discounts index page" do
            describe "Where I see all of my bulk discounts including their" do
              describe "percentage discount and quantity thresholds" do
                it "And each bulk discount listed includes a link to its show page" do

                  visit merchant_dashboard_index_path(@m1)

                  click_link "View My Discounts"

                  expect(current_path).to eq(merchant_bulk_discounts_path(@m1))

                  bulk_discounts = [@discount1, @discount2]

                  bulk_discounts.each do |discount|
                    expect(page).to have_link(discount.name)
                    expect(page).to have_content(discount.percentage)
                    expect(page).to have_content(discount.quantity_threshold)
                  end
                end
              end
            end
          end
        end
      end
    end
  end


  #2: Merchant Bulk Discount Create
  describe "As a merchant" do
    describe "When I visit my bulk discounts index" do
      describe "Then I see a link to create a new discount" do
        describe "When I click this link" do
          describe "Then I am taken to a new page where I see a form to add a new bulk discount" do
            describe "When I fill in the form with valid data" do
              describe "Then I am redirected back to the bulk discount index" do
                it "And I see my new bulk discount listed" do

                  visit merchant_bulk_discounts_path(@m1)

                  click_link "Create a New Discount"

                end
              end
            end
          end
        end
      end
    end
  end
end