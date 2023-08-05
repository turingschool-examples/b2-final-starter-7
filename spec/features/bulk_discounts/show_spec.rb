require "rails_helper"

RSpec.describe "Bulk Discount show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
    visit merchant_bulk_discount_path(@merchant1, @bulk_discount1.id)
  end
  
  #US 4
  it "shows the discounts information" do

    within("#discount_show_page") do
      expect(page).to have_content("#{@bulk_discount1.percentage_discount}% will be take off the total if this discount is applied")
      expect(page).to have_content("#{@bulk_discount1.tag} is the shorthand of this discount")
      expect(page).to have_content("If the consumer buys #{@bulk_discount1.quantity_threshold} or more items, the discount is applied")
    end
  end

    #US5
  it "has a link to edit this discount" do

    within("#edit_discount") do
      expect(page).to have_link("Edit this discount"
      )
      click_on("Edit this discount")
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1))
    end 
    
  end
end