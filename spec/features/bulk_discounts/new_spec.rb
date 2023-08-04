require "rails_helper"

RSpec.describe "Bulk Discount creation page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    visit new_merchant_bulk_discount_path(@merchant1)
  end

  describe "User Story #2" do
    it "should have a form to fill in a new bulk discount" do
      fill_in "Tag", with: "Fifty off Fifty"
      fill_in "Percentage discount", with: 50
      fill_in "Quantity threshold", with: 50
      click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_link("Fifty off Fifty")
    expect(page).to have_content("50% OFF 50 OR MORE OF ONE ITEM"
    )
    end
  end
end