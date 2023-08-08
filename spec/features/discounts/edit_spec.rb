require 'rails_helper'

RSpec.describe 'Mechant Discount edit page', type: :feature do

  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @discount1 = @merchant1.discounts.create!(percent_discount: 10, threshold_quantity: 10)

    visit edit_merchant_discount_path(@merchant1, @discount1)
  end

  it "shows edit discount and current values" do
    expect(page).to have_field("Discount Percent", with: @discount1.percent_discount)
    expect(page).to have_field("Quantity Threshold", with: @discount1.threshold_quantity)
    expect(page).to have_button("Edit Discount")
  end

  it "redirects to show page, edited info appears" do
    expect(@discount1.percent_discount).to eq(10)

    within find("#edit-discount-form") do
      fill_in "Discount Percent", with: 15
      click_button "Edit Discount"
    end

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount: 15%")
    expect(page).to have_content("Discount Successfully Updated!")
  end

  it "shows error when valid integer" do
    within("#edit-discount-form") do
      fill_in "Discount Percent", with: ""
      click_button "Edit Discount"
    end
    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount Not Updated: Fields cannot be empty")
  end
end