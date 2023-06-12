require 'rails_helper'

describe Merchant do
  describe "validations" do
    it { should validate_presence_of :name }

    it "shows that a coupon can be linked to a merchant" do
      linked_merchant = Merchant.create!(name: "Linked Merchant")
      Coupon.create!(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 0, status: 0, merchant_id: linked_merchant.id)
      foo = Coupon.new(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 0, status: 0, merchant_id: linked_merchant.id)
      expect(foo).to_not be_valid
    end

    it "should not be able to create more than five active coupons for one merchant" do
      merchant = Merchant.create!(name: "Eager Merchant")
      coupon_1 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO1", discount_amount: 100, discount_type: 0, status: 0)
      coupon_2 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO2", discount_amount: 100, discount_type: 0, status: 0)
      coupon_3 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO3", discount_amount: 100, discount_type: 0, status: 0)
      coupon_4 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO4", discount_amount: 100, discount_type: 0, status: 0)
      coupon_5 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO5", discount_amount: 100, discount_type: 0, status: 0)
      coupon_6 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO6", discount_amount: 100, discount_type: 0, status: 1) # inactive
      coupon_7 = merchant.coupons.create(name: "Foo", unique_code: "BOGO7", discount_amount: 100, discount_type: 0, status: 0)

      expect(coupon_7.errors.full_messages.to_sentence).to eq("Max Number of Active Coupons Reached: 5")
      expect(coupon_7.save).to eq(false)
    end

    it "should not be able to update a coupon to active when there are already five active coupons for one merchant" do
      merchant = Merchant.create!(name: "Eager Merchant")
      coupon_1 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO1", discount_amount: 100, discount_type: 0, status: 0)
      coupon_2 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO2", discount_amount: 100, discount_type: 0, status: 0)
      coupon_3 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO3", discount_amount: 100, discount_type: 0, status: 0)
      coupon_4 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO4", discount_amount: 100, discount_type: 0, status: 0)
      coupon_5 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO5", discount_amount: 100, discount_type: 0, status: 0)
      coupon_6 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO6", discount_amount: 100, discount_type: 0, status: 1) # inactive

      expect(coupon_6.update(status: "enabled")).to be(false)
      expect(Coupon.all.size).to eq(6)
    end

    it "should not be able to create more than five active coupons for one merchant even if there is another merchant with 5 coupons" do
      merchant = Merchant.create!(name: "Eager Merchant")
      coupon_1 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO1", discount_amount: 100, discount_type: 0, status: 0)
      coupon_2 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO2", discount_amount: 100, discount_type: 0, status: 0)
      coupon_3 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO3", discount_amount: 100, discount_type: 0, status: 0)
      coupon_4 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO4", discount_amount: 100, discount_type: 0, status: 0)
      coupon_5 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO5", discount_amount: 100, discount_type: 0, status: 0)
      coupon_6 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO6", discount_amount: 100, discount_type: 0, status: 1) # inactive
      coupon_7 = merchant.coupons.create(name: "Foo", unique_code: "BOGO7", discount_amount: 100, discount_type: 0, status: 0)

      merchant2 = Merchant.create!(name: "Standard Merchant")
      coupon_11 = merchant2.coupons.create!(name: "Foo", unique_code: "BOGOA1", discount_amount: 100, discount_type: 0, status: 0)
      coupon_12 = merchant2.coupons.create!(name: "Foo", unique_code: "BOGOA2", discount_amount: 100, discount_type: 0, status: 0)
      coupon_13 = merchant2.coupons.create!(name: "Foo", unique_code: "BOGOA3", discount_amount: 100, discount_type: 0, status: 0)
      coupon_14 = merchant2.coupons.create!(name: "Foo", unique_code: "BOGOA4", discount_amount: 100, discount_type: 0, status: 0)
      coupon_15 = merchant2.coupons.create!(name: "Foo", unique_code: "BOGOA5", discount_amount: 100, discount_type: 0, status: 0)

      expect(coupon_7.errors.full_messages.to_sentence).to eq("Max Number of Active Coupons Reached: 5")
      expect(merchant2.coupons.size).to eq(5)
    end
  end

  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:coupons) }
  end

  describe "class methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
      @merchant3 = Merchant.create!(name: 'Office Space')
      @merchant4 = Merchant.create!(name: 'The Office')
      @merchant5 = Merchant.create!(name: 'Office Improvement')
      @merchant6 = Merchant.create!(name: 'Pens & Stuff')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @item_9 = Item.create!(name: "Whiteboard", description: "Erasable", unit_price: 30, merchant: @merchant3)
      @item_10 = Item.create!(name: "Marker", description: "Erasable", unit_price: 3, merchant: @merchant4)
      @item_11 = Item.create!(name: "Eraser", description: "Felt", unit_price: 6, merchant: @merchant5)
      @item_12 = Item.create!(name: "Sharpie", description: "Permanent", unit_price: 4, merchant: @merchant6)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      @invoice_9 = Invoice.create!(customer: @customer_1, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_9.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_12 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_10.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_13 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_11.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_14 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_12.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
      @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_9.id)

    end

    it 'top_merchants' do
      actual = Merchant.top_merchants.map do |result|
        result.name
      end
      expect(actual).to match_array([@merchant1.name, @merchant3.name, @merchant4.name, @merchant5.name, @merchant6.name])
    end
  end

  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)

    end
    it "can list items ready to ship" do
      expect(@merchant1.ordered_items_to_ship).to eq([@item_1, @item_1, @item_3, @item_4, @item_7, @item_8, @item_4, @item_4])
    end

    it "shows a list of favorite customers" do
      actual = @merchant1.favorite_customers.map do |customer|
        customer[:first_name]
      end
      expect(actual).to eq([@customer_1.first_name, @customer_2.first_name, @customer_3.first_name, @customer_4.first_name, @customer_6.first_name])
    end

    it "top_5_items" do
      expect(@merchant1.top_5_items).to eq([@item_1, @item_2, @item_3, @item_8, @item_4])
    end

    it "best_day" do
      expect(@merchant1.best_day).to eq(@invoice_8.created_at.to_date)
    end

    it "enabled_items" do
      expect(@merchant1.enabled_items).to eq([@item_1])
      expect(@merchant2.enabled_items).to eq([])
    end

    it "disabled_items" do
      expect(@merchant1.disabled_items).to eq([@item_2, @item_3, @item_4, @item_7, @item_8])
      expect(@merchant2.disabled_items).to eq([@item_5, @item_6])
    end

    # it "active_coupon_protection?" do
    #   merchant4 = Merchant.create!(name: "Hair Care")

    #   coupon_1 = merchant4.coupons.create!(name: "Five Dollars", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
    #   coupon_2 = merchant4.coupons.create!(name: "Ten Dollars", unique_code: "TENHC", discount_amount: 10, discount_type: 0, status: 0)
    #   coupon_3 = merchant4.coupons.create!(name: "Five Percent", unique_code: "FIVEPRCHC", discount_amount: 5, discount_type: 1, status: 0)
    #   coupon_4 = merchant4.coupons.create!(name: "Ten Percent", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
    #   coupon_5 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC", discount_amount: 20, discount_type: 1, status: 0)

    #   expect(merchant4.active_coupon_protection?).to be(true)
    # end

    it "#active_coupons" do
      merchant4 = Merchant.create!(name: "Hair Care")

      coupon_1 = merchant4.coupons.create!(name: "Five Dollars", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
      coupon_2 = merchant4.coupons.create!(name: "Ten Dollars", unique_code: "TENHC", discount_amount: 10, discount_type: 0, status: 0)
      coupon_3 = merchant4.coupons.create!(name: "Five Percent", unique_code: "FIVEPRCHC", discount_amount: 5, discount_type: 1, status: 0)
      coupon_4 = merchant4.coupons.create!(name: "Ten Percent", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
      coupon_5 = merchant4.coupons.create!(name: "Old", unique_code: "OLDHC", discount_amount: 20, discount_type: 1, status: 0)
      coupon_6 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC6", discount_amount: 20, discount_type: 1, status: 1)
      coupon_7 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC7", discount_amount: 20, discount_type: 1, status: 1)
      coupon_8 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC8", discount_amount: 20, discount_type: 1, status: 1)

      expect(merchant4.active_coupons).to eq([coupon_1, coupon_2, coupon_3, coupon_4, coupon_5])
    end

    it "#inactive_coupons" do
      merchant4 = Merchant.create!(name: "Hair Care")

      coupon_1 = merchant4.coupons.create!(name: "Five Dollars", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
      coupon_2 = merchant4.coupons.create!(name: "Ten Dollars", unique_code: "TENHC", discount_amount: 10, discount_type: 0, status: 0)
      coupon_3 = merchant4.coupons.create!(name: "Five Percent", unique_code: "FIVEPRCHC", discount_amount: 5, discount_type: 1, status: 0)
      coupon_4 = merchant4.coupons.create!(name: "Ten Percent", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
      coupon_5 = merchant4.coupons.create!(name: "Old", unique_code: "OLDHC", discount_amount: 20, discount_type: 1, status: 0)
      coupon_6 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC6", discount_amount: 20, discount_type: 1, status: 1)
      coupon_7 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC7", discount_amount: 20, discount_type: 1, status: 1)
      coupon_8 = merchant4.coupons.create!(name: "Deactivated", unique_code: "OLDHC8", discount_amount: 20, discount_type: 1, status: 1)

      expect(merchant4.inactive_coupons).to eq([coupon_6, coupon_7, coupon_8])
    end
  end
end
