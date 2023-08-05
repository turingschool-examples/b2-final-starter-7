require "rails_helper"

RSpec.describe "Bulk Discount edit page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)
  end

  it "Fills out a form to edit a discount" do
    fill_in "Tag", with: "25% off"
    fill_in "Percentage discount", with: 25
    fill_in "Quantity threshold", with: 20
    click_button "Submit"
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount1.id))
    expect(page).to have_content("25% off is the shorthand of this discount")
    expect(page).to have_content("25% will be take off the total if this discount is applied")
    expect(page).to have_content("If the consumer buys 20 or more items, the discount is applied")
  end
end
