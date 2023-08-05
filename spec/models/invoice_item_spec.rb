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
      @m2 = Merchant.create!(name: 'Merchant 2')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @item_4 = Item.create!(name: 'Comb', description: 'This also takes out tangles', unit_price: 3, merchant_id: @m2.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 0)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 5, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 12, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 25, unit_price: 5, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_4.id, quantity: 25, unit_price: 5, status: 2)
      @discount_1 = Discount.create!(merchant_id: @m1.id, percentage: "10", threshold: 10)
      @discount_2 = Discount.create!(merchant_id: @m1.id, percentage: "15", threshold: 15)
      @discount_3 = Discount.create!(merchant_id: @m1.id, percentage: "20", threshold: 20)
      @discount_4 = Discount.create!(merchant_id: @m1.id, percentage: "5", threshold: 5)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end

    it ".best_discount_id" do
      expect(@ii_2.best_discount_id).to eq(@discount_4.id)
      expect(@ii_3.best_discount_id).to eq(@discount_1.id)
      expect(@ii_4.best_discount_id).to eq(@discount_3.id)
      # test for qty under all thresholds
      expect(@ii_1.best_discount_id).to eq(nil)
      # test for second merchant item with Qty 25, merchant has no discounts
      expect(@ii_5.best_discount_id).to eq(nil)

    end
  end
end
