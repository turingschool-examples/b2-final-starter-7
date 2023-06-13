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
    it { should belong_to(:coupon).optional }
  end

  describe "instance methods" do
    it "sub_total" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.sub_total).to eq(100)
    end

    context "#discount_total" do
      it "returns a dollar amount for dollar discount coupons" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @coupon1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.discount_total).to eq(5.0)
      end

      it "returns a 0 dollar amount if there are no coupons" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @coupon1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
        @coupon2 = @merchant1.coupons.create!(name: "10%", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.discount_total).to eq(0.0)
      end

      it "returns a dollar amount for percentage absed coupons" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        # @coupon1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
        @coupon2 = @merchant1.coupons.create!(name: "10%", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon2.id, created_at: "2012-03-27 14:54:09")
        # @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon2.id, created_at: "2012-03-28 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.discount_total).to eq(10.0)
      end
    end

    context "#grand_total_revenue" do
      it "rthe grand total dollar amount for dollar discount coupons" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @coupon1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.grand_total_revenue).to eq(95.0)
      end

      it "returns a sub-total amount if there are no coupons" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @coupon1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
        @coupon2 = @merchant1.coupons.create!(name: "10%", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.grand_total_revenue).to eq(100.0)
      end

      it "returns a grand total dollar amount for percentage based coupons" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @coupon2 = @merchant1.coupons.create!(name: "10%", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon2.id, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.grand_total_revenue).to eq(90.0)
      end

      it "doesn't return a less than 0 dollar amount" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @coupon3 = @merchant1.coupons.create!(name: "Millionaire", unique_code: "MILLIONAIREHC", discount_amount: 1_000_000_000, discount_type: 0, status: 0)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon3.id, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.grand_total_revenue).to eq(0.0)
      end
    end
  end
end
