require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "Pre-baked tests" do
    describe "validations" do
      it { should validate_presence_of :status }
      it { should validate_presence_of :customer_id }
    end
    describe "relationships" do
      it { should belong_to :customer }
      it { should have_many(:items).through(:invoice_items) }
      it { should have_many(:merchants).through(:items) }
      it { should have_many :transactions}
    end
    describe "instance methods" do
      it "total_revenue" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.total_revenue).to eq(100)
      end
    end
  end
  describe "Final Solo Project: " do
    describe ".total_discount" do
      it "Should return correct discount based on individual item quantities" do
        merchant = Merchant.create!(name: 'Hair Care')
        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
        item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant.id)
        customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice = Invoice.create!(customer_id: customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        ii_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 22, unit_price: 10, status: 2)
        ii_11 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_8.id, quantity: 10, unit_price: 5, status: 1)
        
        expect(invoice.total_discount).to eq(0)
        discount_4 = Discount.create!(merchant_id: merchant.id, percentage: "5", threshold: 5)
        expect(invoice.total_discount).to eq(13.5)
        discount_1 = Discount.create!(merchant_id: merchant.id, percentage: "10", threshold: 10)
        expect(invoice.total_discount).to eq(27)
        discount_2 = Discount.create!(merchant_id: merchant.id, percentage: "15", threshold: 15)
        expect(invoice.total_discount).to eq(38)
        discount_3 = Discount.create!(merchant_id: merchant.id, percentage: "20", threshold: 20)
        expect(invoice.total_discount).to eq(49)

        # Edge case where threshold is high but discount is low
        discount_5 = Discount.create!(merchant_id: merchant.id, percentage: "5", threshold: 15)
        expect(invoice.total_discount).to eq(49)
        
        # Edge case where threshold is low but discount is high
        discount_5 = Discount.create!(merchant_id: merchant.id, percentage: "25", threshold: 15)
        expect(invoice.total_discount).to eq(60)
      end
    end
    describe ".discounted_revenue" do
      it "should return the 'total_revenue' minus the 'total_discount'" do
        merchant = Merchant.create!(name: 'Hair Care')
        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
        item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant.id)
        customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice = Invoice.create!(customer_id: customer.id, status: 2, created_at: "2012-03-27 14:54:09")
        ii_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 22, unit_price: 10, status: 2)
        ii_11 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_8.id, quantity: 10, unit_price: 5, status: 1)
        
        discount_4 = Discount.create!(merchant_id: merchant.id, percentage: "5", threshold: 5)
        discount_1 = Discount.create!(merchant_id: merchant.id, percentage: "10", threshold: 10)
        expect(invoice.total_revenue).to eq(270)
        expect(invoice.total_discount).to eq(27)
        expect(invoice.discounted_revenue).to eq(243)
      end
    end
  end
end
