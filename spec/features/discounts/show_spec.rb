require "rails_helper"

RSpec.describe "discount show" do
  before :each do
    @merchant1 = Merchant.create!(name: "Josie's Hair Care")

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

    @discount_1 = Discount.create!(merchant_id: @merchant1.id, percentage: "10", threshold: 10)
    @discount_2 = Discount.create!(merchant_id: @merchant1.id, percentage: "15", threshold: 15)
    @discount_3 = Discount.create!(merchant_id: @merchant1.id, percentage: "20", threshold: 20)
    @discounts = [@discount_1, @discount_2, @discount_3]

    visit merchant_discount_path(@merchant1.id, @discount_1.id)
  end
  
  describe "Final Solo Project: " do
    describe "As a merchant When I visit my bulk discount show page" do 
      it "US4.a Then I see the bulk discount's quantity threshold and percentage discount" do
        within "#discount_details" do
          expect(page).to have_content("#{@discount_1.id}")
        end
        within "#percentage_#{@discount_1.id}" do
          expect(page).to have_content("#{@discount_1.percentage}")
        end
        within "#threshold_#{@discount_1.id}" do
          expect(page).to have_content("#{@discount_1.threshold}")
        end
      end
      
      it "US5.a Then I see a link to edit the bulk discount" do
        within "#discount_details" do
          expect(page).to have_link("Edit Discount")
        end
      end
      it "US5.b When I click this link Then I am taken to a new page with a form to edit the discount And I see that the discounts current attributes are pre-poluated in the form" do
        within "#discount_details" do
          click_link("Edit Discount")
        end
        expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount_1.id}/edit")
        expect(page).to have_css("#discount_edit_form")
        within("#discount_edit_form") do
          expect(find_field("discount[percentage]").value).to eq("#{@discount_1.percentage}")
          expect(find_field("discount[threshold]").value).to eq("#{@discount_1.threshold}")
        end
      end
      it "US5.c When I change any/all of the information and click submit Then I am redirected to the bulk discount's show page And I see that the discount's attributes have been updated" do
        visit "/merchants/#{@merchant1.id}/discounts/#{@discount_1.id}/edit"
        within("#discount_edit_form") do
          fill_in "discount[percentage]", with: "999"
          fill_in"discount[threshold]", with: "50"
          click_button "Update Discount"
        end
        
        expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount_1.id}")
        within "#flash_message" do
          expect(page).to have_content("Bulk discount updated")
        end
        within "#discount_details" do
          expect(page).to have_content("#{@discount_1.id}")
          expect(page).to_not have_content("#{@discount_1.percentage}")
          expect(page).to_not have_content("#{@discount_1.threshold}")
          expect(page).to have_content("999")
          expect(page).to have_content("50")
        end
      end
      it "US5.d.sad_path should not allow invalid entries" do
        visit "/merchants/#{@merchant1.id}/discounts/#{@discount_1.id}/edit"
        within("#discount_edit_form") do
          fill_in "discount[percentage]", with: "text"
          click_button "Update Discount"
        end
        
        expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount_1.id}")
        within "#flash_message" do
          expect(page).to have_content("Invalid information. Please try again.")
        end
        within("#discount_edit_form") do
          fill_in "discount[threshold]", with: "-50"
          click_button "Update Discount"
        end
        
        expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount_1.id}")
        within "#flash_message" do
          expect(page).to have_content("Invalid information. Please try again.")
        end
      end
    end
  end
end