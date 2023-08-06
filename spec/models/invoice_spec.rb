require 'rails_helper'

RSpec.describe Invoice, type: :model do
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

    describe "#total_revenue" do
      it "calculates its total revenue, not including discounts" do
        expect(@invoice_1.total_revenue).to eq(100)
        expect(@invoice_2.total_revenue).to eq(295)
      end
    end

    describe "#total_discounted_revenue" do
      it "applies the single highest eligible % discount to each item group" do
        expect(@invoice_2.total_discounted_revenue).to eq(220)
      end

      it "can have multiple item groups eligible for different discounts" do
        expect(@invoice_3.total_discounted_revenue).to eq(3335.5)
      end

      it "can apply multiple vendors' discounts to their respective items on a single invoice" do
        expect(@invoice_4.total_discounted_revenue).to eq(1498.5)
      end

      it "will not alter the invoice revenue for invoices with no discount" do
        expect(@invoice_1.total_revenue).to eq(100)
        expect(@invoice_1.total_discounted_revenue).to eq(100)
      end
    end
  end
end
