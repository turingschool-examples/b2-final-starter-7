require 'rails_helper'

RSpec.describe 'Merchant Discounts Page', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    visit new_merchant_discount_path(@merchant1) 
  end

  describe "merchant discount page, form to add a new discount" do
    it "has form to add a new discount" do
      within("#new-discount") do
        expect(page).to have_field("Discount Percent")
        expect(page).to have_field("Quantity Threshold")
        expect(page).to have_button("Add Discount")
      end
    end

    it "redirects to merchant discounts index, shows new discount" do
      within("#new-discount") do
        fill_in "Discount Percent", with: 50
        fill_in "Quantity Threshold", with: 25
        click_button "Add Discount"
      end

      expect(current_path).to eq(merchant_discounts_path(@merchant1))

      expect(page).to have_content("Discount: 50% - Quantity Threshold: 25", count: 1)
      expect(page).to have_content("Discount Successfully Added!")
    end

    it "error when form not complete" do
      within("#new-discount") do
        click_button "Add Discount"
      end
      expect(page).to have_content("Discount Not created: Required information missing")
    end
  end
end