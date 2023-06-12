require "rails_helper"

RSpec.describe "merchant coupon create", type: :feature do
  describe "coupon creations" do
    before :each do
      @merchant1 = Merchant.create!(name: "Hair Care")

      @coupon_1 = @merchant1.coupons.create!(name: "Five Dollars", unique_code: "FIVEHC", discount_amount: 5, discount_type: 0, status: 0)
      @coupon_2 = @merchant1.coupons.create!(name: "Ten Dollars", unique_code: "TENHC", discount_amount: 10, discount_type: 0, status: 0)
      @coupon_3 = @merchant1.coupons.create!(name: "Five Percent", unique_code: "FIVEPRCHC", discount_amount: 5, discount_type: 1, status: 0)
      @coupon_4 = @merchant1.coupons.create!(name: "Ten Percent", unique_code: "TENPRCHC", discount_amount: 10, discount_type: 1, status: 0)
      @coupon_5 = @merchant1.coupons.create!(name: "Deactivated", unique_code: "OLDHC", discount_amount: 20, discount_type: 1, status: 1)

      visit new_merchant_coupon_path(@merchant1)
    end

    context "happy path" do
      it "has a form to create a new coupon" do
        expect(page).to have_content("Create a New Coupon")

        fill_in(:name, with: "New Coupon")
        fill_in(:unique_code, with: "HALFOFFHC")
        fill_in(:discount_amount, with: 50)
        page.select "percentage", from: :discount_type
        click_button("Create new Coupon")

        expect(current_path).to eq(merchant_coupons_path(@merchant1))

        new_coupon = Coupon.last
        # @merchant1.reload

        visit merchant_coupons_path(@merchant1)

        within "#active-coupons" do
          expect(page).to have_content("Coupon Name: #{new_coupon.name} | Discount Amount: 50% off")
        end

        expect(new_coupon.name).to eq("New Coupon")
        expect(new_coupon.unique_code).to eq("HALFOFFHC")
        expect(new_coupon.discount_amount).to eq(50)
        expect(new_coupon.discount_type).to eq("percentage")
        expect(new_coupon.merchant).to eq(@merchant1)
      end
    end

    context "sad path: non-unique code" do
      it "has a form to create a new coupon and flashes error for uniquesness" do
        coupon_6 = @merchant1.coupons.create!(name: "New Coupon", unique_code: "HALFOFFHC", discount_amount: 50, discount_type: 1, status: 1)

        fill_in(:name, with: "New Coupon")
        fill_in(:unique_code, with: "HALFOFFHC")
        fill_in(:discount_amount, with: 50)
        page.select "percentage", from: :discount_type

        click_button("Create new Coupon")

        coupon_created_with_errors = Coupon.last

        expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
        expect(page).to have_content("Error: Unique code has already been taken")
      end
    end

    context "sad path: too many active coupons" do
      it "has a form to create a new coupon and flashes error for too many acitive coupons" do
        coupon_6 = @merchant1.coupons.create!(name: "New Coupon", unique_code: "HALFOFFHC", discount_amount: 50, discount_type: 1, status: 0)

        fill_in(:name, with: "New Coupon")
        fill_in(:unique_code, with: "SUMMER25HC")
        fill_in(:discount_amount, with: 50)
        page.select "percentage", from: :discount_type

        click_button("Create new Coupon")

        coupon_created_with_errors = Coupon.last

        expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
        expect(page).to have_content("Error: Max Number of Active Coupons Reached: 5")
        ## REFACTOR with base error message
        # expect(page).to have_content("#{coupon_created_with_errors.errors.full_messages.to_sentence}")
      end
    end
  end
end
