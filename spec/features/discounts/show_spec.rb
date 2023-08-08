require 'rails_helper'

RSpec.describe 'Merchant Discount Show Page', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @discount1 = @merchant1.discounts.create!(percent_discount: 10, threshold_quantity: 10)

    visit merchant_discount_path(@merchant1, @discount1)
  end

  it "shows discount quantity threshold and percentage discount" do
    expect(page).to have_content("Discount: #{@discount1.percent_discount}%", count: 1)
    expect(page).to have_content("Quantity Threshold: #{@discount1.threshold_quantity}", count: 1)
  end

  it "has update button" do
    expect(page).to have_button("Update")

    find("#update-discount-#{@discount1.id}").click

    expect(current_path).to eq(update_merchant_discount_path(@merchant1, @discount1))
  end
end