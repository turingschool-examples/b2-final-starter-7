require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "Exsist" do
    it "exsists" do
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :kind }
    it { should validate_uniqueness_of :code }

    it { should belong_to :merchant }
    it { should have_many :invoices }
  end

  describe "methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @merchant2 = Merchant.create!(name: "Jewelry")

      @coupon1 = Coupon.create!(status: 1, code: "20off", name: "20 perc off", perc_disc: 20, dollar_disc: 0, kind: 0, merchant_id: @merchant1.id)
      @coupon2 = Coupon.create!(status: 1, code: "10off", name: "10 dollers off", perc_disc: 0, dollar_disc: 10, kind: 1, merchant_id: @merchant1.id)
      @coupon3 = Coupon.create!(status: 1, code: "15off", name: "15 dollers off", perc_disc: 0, dollar_disc: 15, kind: 1, merchant_id: @merchant1.id)
      @coupon4 = Coupon.create!(status: 1, code: "25off", name: "25 dollers off", perc_disc: 0, dollar_disc: 25, kind: 1, merchant_id: @merchant1.id)
      @coupon5 = Coupon.create!(status: 0, code: "35off", name: "35 dollers off", perc_disc: 0, dollar_disc: 35, kind: 1, merchant_id: @merchant1.id)

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

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")

      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, coupon_id: @coupon1.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, coupon_id: @coupon1.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, coupon_id: @coupon2.id, status: 2) #invoice status 0 cancelled 1 in progress 2 completed

      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, coupon_id: @coupon3.id, status: 1)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, coupon_id: @coupon3.id, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0) #invoice item status 0pending 1packaged 2shipped
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id) #transaction result 0failed 1 success
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)#
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)#
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)#
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
    end

    it "can call on its successful transactions" do
      expect(@coupon1.used_transactions).to eq(2)
      expect(@coupon2.used_transactions).to eq(1)
    end

    it "can find if on pending invoices" do
      expect(@coupon3.pending_invoices?).to eq(true)
      expect(@coupon1.pending_invoices?).to eq(false)
    end
  end
end
