require "rails_helper"

RSpec.describe "Coupon Index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Dolly Parton")
    @coupon1 = @merchant1.coupons.create!(name: "Ten Percent Off", unique_code: "10%OFF", amount_off: 10, discount: 1, status: 1)
    @coupon2 = @merchant1.coupons.create!(name: "Five Percent Off", unique_code: "5%OFF", amount_off: 5, discount: 1, status: 1)
    @coupon3 = @merchant1.coupons.create!(name: "Fifteen Percent Off", unique_code: "15%OFF", amount_off: 15, discount: 1, status: 1)
    @coupon4 = @merchant1.coupons.create!(name: "Ten Dollars Off", unique_code: "10$OFF", amount_off: 10, discount: 0, status: 1)
    @coupon5 = @merchant1.coupons.create!(name: "Twelve Percent Off", unique_code: "12%OFF",amount_off: 12, discount: 1, status: 0)

  end

  describe "US1 merchant_coupons_path(@merchant1)" do
    it "I see all of my coupon names including their amount off And each coupon's name is also a link to its show page." do
      visit merchant_coupons_path(@merchant1)
save_and_open_page
      expect(page).to have_content("Coupon Index Page")
      expect(page).to have_content("Ten Percent Off")
    end
  end
end
