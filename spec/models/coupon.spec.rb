require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: "Dolly Parton")
    @coupon1 = @merchant1.coupons.create!(name: "Ten Percent Off", unique_code: "10%OFF", amount_off: 10, discount: 1, status: 1)
    @coupon2 = @merchant1.coupons.create!(name: "Five Percent Off", unique_code: "5%OFF", amount_off: 5, discount: 1, status: 1)
    @coupon3 = @merchant1.coupons.create!(name: "Fifteen Percent Off", unique_code: "15%OFF", amount_off: 15, discount: 1, status: 1)
    @coupon4 = @merchant1.coupons.create!(name: "Ten Dollars Off", unique_code: "10$OFF", amount_off: 10, discount: 0, status: 1)
    @coupon5 = @merchant1.coupons.create!(name: "Twelve Percent Off", unique_code: "12%OFF",amount_off: 12, discount: 1, status: 0)

end
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unique_code }
    it { should validate_presence_of :discount }
    it { should validate_presence_of :status }
    it { should validate_numericality_of (:amount_off) }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices}
  end
end