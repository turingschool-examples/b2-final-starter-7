require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name).on(:create) }
    it { should validate_presence_of(:discount_amount).on(:create) }
    it { should validate_presence_of(:discount_type).on(:create) }
    it { should validate_numericality_of(:discount_amount).on(:create) }

    it "validates the uniqueness of a unique code for dollar discount type" do
      merchant = Merchant.create!(name: "Test Merchant")
      Coupon.create!(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 0, merchant_id: merchant.id)
      foo = Coupon.new(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 0, merchant_id: merchant.id)
      expect(foo).to_not be_valid
    end

    it "validates the uniqueness of a unique code for percentage discount type" do
      merchant = Merchant.create!(name: "Test Merchant")
      Coupon.create!(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 1, merchant_id: merchant.id)
      foo = Coupon.new(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 1, merchant_id: merchant.id)
      expect(foo).to_not be_valid
    end

    it "validates the discount amount is greater than 0" do
      merchant = Merchant.create!(name: "Test Merchant")
      Coupon.create!(name: "Foo", unique_code: "BOGO", discount_amount: 100, discount_type: 0, merchant_id: merchant.id)
      foo = Coupon.new(name: "Foo", unique_code: "BOGO50", discount_amount: 0, discount_type: 0, merchant_id: merchant.id)
      expect(foo).to_not be_valid
    end

    # it "should not be able to create more than five active coupons" do
    #   merchant = Merchant.create!(name: "Eager Merchant")
    #   coupon_1 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO1", discount_amount: 100, discount_type: 0, status: 0)
    #   coupon_2 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO2", discount_amount: 100, discount_type: 0, status: 0)
    #   coupon_3 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO3", discount_amount: 100, discount_type: 0, status: 0)
    #   coupon_4 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO4", discount_amount: 100, discount_type: 0, status: 0)
    #   coupon_5 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO5", discount_amount: 100, discount_type: 0, status: 0)
    #   coupon_6 = merchant.coupons.create!(name: "Foo", unique_code: "BOGO6", discount_amount: 100, discount_type: 0, status: 1)
    #   coupon_7 = Coupon.new(name: "Foo", unique_code: "BOGO7", discount_amount: 100, discount_type: 0, status: 0, merchant_id: merchant.id)

    #   expect(coupon_1).to be_valid
    #   expect(coupon_2).to be_valid
    #   expect(coupon_3).to be_valid
    #   expect(coupon_4).to be_valid
    #   expect(coupon_5).to be_valid
    #   expect(coupon_6).to be_valid
    #   expect(coupon_7).to_not be_valid
    # end
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many(:invoices) }
  end

end
