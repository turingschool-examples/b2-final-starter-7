require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end

  describe "instance methods" do
    before do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Vintage Shop')
      @item_1 = @merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, status: 1)
      @item_2 = @merchant1.items.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5)
      @item_3 = @merchant2.items.create!(name: "Scarf", description: "This goes around your neck", unit_price: 15)
      @item_4 = @merchant2.items.create!(name: "Jeans", description: "These are from the 70s", unit_price: 80)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = @customer_1.invoices.create!(status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = @customer_1.invoices.create!(status: 2, created_at: "2012-03-28 14:54:09")
      @invoice_3 = @customer_1.invoices.create!(status: 2, created_at: "2012-04-09 14:54:09")
      @invoice_4 = @customer_1.invoices.create!(status: 2, created_at: "2012-04-15 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 25, unit_price: 10, status: 1)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 9, unit_price: 5, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 29, unit_price: 15, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 46, unit_price: 80, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_2.id, quantity: 13, unit_price: 5, status: 1)
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 20, unit_price: 80, status: 1)
      
      @discount_1 = @merchant1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10)
      @discount_2 = @merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
      @discount_3 = @merchant1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 25)
      @discount_4 = @merchant2.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 20)
      @discount_5 = @merchant2.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 30)
    end

    describe "#eligible_discount" do
      it "returns the bulk discount that the invoice item is eligible for" do
        expect(@ii_1.eligible_discount).to eq(nil)
        expect(@ii_2.eligible_discount).to eq(nil)
        expect(@ii_3.eligible_discount).to eq(@discount_3)
        expect(@ii_4.eligible_discount).to eq(nil)
        expect(@ii_5.eligible_discount).to eq(@discount_4)
        expect(@ii_6.eligible_discount).to eq(@discount_5)
        expect(@ii_7.eligible_discount).to eq(@discount_1)
        expect(@ii_8.eligible_discount).to eq(@discount_4)
      end
    end

    describe "#original_price" do
      it "returns the invoice item price before discounts" do
        expect(@ii_3.original_price).to eq(250)
        expect(@ii_5.original_price).to eq(435)
        expect(@ii_6.original_price).to eq(3680)
        expect(@ii_7.original_price).to eq(65)
        expect(@ii_8.original_price).to eq(1600)

      end
    end

    describe "final_price" do
      it "returns the invoice item price after discounts" do
        expect(@ii_3.final_price).to eq(175)
        expect(@ii_5.final_price).to eq(391.5)
        expect(@ii_6.final_price).to eq(2944)
        expect(@ii_7.final_price).to eq(58.5)
        expect(@ii_8.final_price).to eq(1440)
      end

      it "will not apply discounts to invoice items that do not qualify" do
        expect(@ii_1.original_price).to eq(90)
        expect(@ii_1.final_price).to eq(90)

        expect(@ii_2.original_price).to eq(10)
        expect(@ii_2.final_price).to eq(10)

        expect(@ii_4.original_price).to eq(45)
        expect(@ii_4.final_price).to eq(45)
      end
    end
  end 
end
