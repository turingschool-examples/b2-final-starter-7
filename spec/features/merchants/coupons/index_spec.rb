require "rails_helper"

RSpec.describe "merchant coupon index", type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon_1 = @merchant1.coupons.create!(name: "$5", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
    @coupon_2 = @merchant1.coupons.create!(name: "$10", unique_code: "TENHC", discount_amount: 100, discount_type: 0, status: 0)
    @coupon_3 = @merchant1.coupons.create!(name: "$1,000,000", unique_code: "MILLIONHC", discount_amount: 1_000_000, discount_type: 0, status: 0)
    @coupon_4 = @merchant1.coupons.create!(name: "5%", unique_code: "FIVEPRCHC", discount_amount: 5, discount_type: 1, status: 0)
    @coupon_5 = @merchant1.coupons.create!(name: "10%", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)

    @merchant2 = Merchant.create!(name: "Nail Care")

    @coupon_6 = @merchant2.coupons.create!(name: "Fiver", unique_code: "FIVENC", discount_amount: 5, discount_type: 0, status: 0)
    @coupon_7 = @merchant2.coupons.create!(name: "Tenner", unique_code: "TENNC", discount_amount: 100, discount_type: 0, status: 0)
    @coupon_8 = @merchant2.coupons.create!(name: "Millionaire", unique_code: "MILLIONNC", discount_amount: 1_000_000, discount_type: 0, status: 0)
    @coupon_9 = @merchant2.coupons.create!(name: "Five Percent", unique_code: "FIVEPRCNC", discount_amount: 5, discount_type: 1, status: 0)
    @coupon_10 = @merchant2.coupons.create!(name: "Ten Percent", unique_code: "TENPRCNC", discount_amount: 10, discount_type: 1, status: 0)

    visit merchant_coupons_path(@merchant1)
  end
  
  it "shows the merchant's coupons" do
    expect(page).to have_content("#{@merchant1.name}'s Coupons")

    within "##{@merchant1.id}-coupons" do
      expect(page).to have_content("Coupon Name: #{@coupon_1.name} | Discount Amount: $#{@coupon_1.discount_amount} off")
      expect(page).to have_content("Coupon Name: #{@coupon_2.name} | Discount Amount: $#{@coupon_2.discount_amount} off")
      expect(page).to have_content("Coupon Name: #{@coupon_3.name} | Discount Amount: $1,000,000 off")
      expect(page).to have_content("Coupon Name: #{@coupon_4.name} | Discount Amount: 5% off")
      expect(page).to have_content("Coupon Name: #{@coupon_5.name} | Discount Amount: 10% off")
      # Could refactor later to include spec helper to utilize view-helpers...
      # module ViewHelpers
      #   def h
      #     ViewHelper.instance
      #   end

      #   class ViewHelper
      #     include Singleton
      #     include ActionView::Helpers::NumberHelper
      #     include ApplicationHelper
      #   end
      # end

      # RSpec.configure do |config|
      #   config.include ViewHelpers
      # end
      # xample_spec.rb
      # require 'rails_helper'

      # feature 'some feature' do
      #   scenario 'can see the percentage' do
      #     savings = # Use rails view helpers freely in spec!
      #       h.number_to_percentage(3.00, strip_insignificant_zeros: true)
      #     expect(savings).to eq "3%"
      #   end
      # end
      expect(page).to_not have_content("Coupon Name: #{@coupon_6.name} | Discount Amount: $#{@coupon_6.discount_amount} off")
    end
  end

  it "has a link to create a new coupon" do
    click_link("Create New Coupon", href: new_merchant_coupon_path(@merchant1))
  end
end
