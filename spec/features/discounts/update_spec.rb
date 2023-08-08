require 'rails_helper'

RSpec.describe 'Mechant Discount update page', type: :feature do

  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @discount1 = @merchant1.discounts.create!(percent_discount: 10, threshold_quantity: 10)

    visit update_merchant_discount_path(@merchant1, @discount1)
  end

  it "shows update discount and current values" do
    expect(page).to have_field("Discount Percent", with: @discount1.percent_discount)
    expect(page).to have_field("Quantity Threshold", with: @discount1.threshold_quantity)
    expect(page).to have_button("Save Changes")
  end

  it "redirects to show page, updated info appears" do
    expect(@discount1.percent_discount).to eq(10)

    within("#update-discount-form") do
      fill_in "Discount Percent", with: 15
      click_button "Save Changes"
    end

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount: 15%")
    expect(page).to have_content("Discount Successfully Updated!")
  end

  it "shows error when valid integer" do
    within("#update-discount-form") do
      fill_in "Discount Percent", with: ""
      click_button "Save Changes"
    end
    expect(current_path).to eq(update_merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount Not Updated: Fields cannot be empty")
  end
end