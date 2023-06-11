require "rails_helper"

describe "merchant coupons index" do

  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @coupon1 = Coupon.create!(status: 1, code: "20off", name: "20 perc off", perc_disc: 20, dollar_disc: 0, kind: 0, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(status: 1, code: "10off", name: "10 dollers off", perc_disc: 0, dollar_disc: 10, kind: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create!(status: 1, code: "15off", name: "15 dollers off", perc_disc: 0, dollar_disc: 15, kind: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create!(status: 1, code: "25off", name: "25 dollers off", perc_disc: 0, dollar_disc: 25, kind: 1, merchant_id: @merchant1.id)
    @coupon5 = Coupon.create!(status: 0, code: "35off", name: "35 dollers off", perc_disc: 0, dollar_disc: 35, kind: 1, merchant_id: @merchant1.id)
    @coupon6 = Coupon.create!(status: 1, code: "100off", name: "100 dollers off", perc_disc: 0, dollar_disc: 100, kind: 1, merchant_id: @merchant2.id)

    visit merchant_coupons_path(@merchant1)
  end

  it "can see a list of all the names of my coupons and not coupons for other merchants" do
    expect(page).to have_content(@coupon1.name)
    expect(page).to have_content(@coupon2.name)
    expect(page).to have_content(@coupon3.name)
    expect(page).to have_content(@coupon4.name)
    expect(page).to have_content(@coupon5.name)

    expect(page).to have_no_content(@coupon6.name)
  end

  it "When I click on a coupon name in my coupon index I am taken to that coupons show page" do
    within("#activated") do
      expect(page).to have_link(@coupon1.name)

      click_link "#{@coupon1.name}"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}")
    end
  end

  it "There is a link to create a new coupon on coupon index page, Coupons are created as deactivated by default" do
    click_link "Create New Coupon"
    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))

    fill_in "Name", with: "Flash Sale 50"
    fill_in "Code", with: "flash50"
    fill_in "Percent Discount", with: "50"
    select "Percentage", from: "kind"
    click_button "Submit"

    expect(current_path).to eq(merchant_coupons_path(@merchant1))
    within("#deactivated") do
      expect(page).to have_content("Flash Sale 50")
    end
    within("#activated") do
      expect(page).to_not have_content("Flash Sale 50")
    end
  end

  it "Cupon code must be unique" do
    click_link "Create New Coupon"
    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))

    fill_in "Name", with: "Flash Sale 50"
    fill_in "Code", with: "20off"
    select "activated", from: "status"
    fill_in "Percent Discount", with: "50"
    select "Percentage", from: "kind"
    click_button "Submit"

    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
    expect(page).to have_content("Coupon name not unique.")
  end

  it "Can only have 5 active coupons" do
    click_link "Create New Coupon"
    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))

    fill_in "Name", with: "Flash 50"
    fill_in "Code", with: "fla50"
    select "activated", from: "status"
    fill_in "Percent Discount", with: "50"
    select "Percentage", from: "kind"
    click_button "Submit"
    expect(current_path).to eq(merchant_coupons_path(@merchant1))
    within("#activated") do
      expect(page).to have_content("Flash 50")
    end

    click_link "Create New Coupon"
    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))

    fill_in "Name", with: "New Activated"
    fill_in "Code", with: "activatecoup"
    select "activated", from: "status"
    fill_in "Percent Discount", with: "50"
    select "Percentage", from: "kind"
    click_button "Submit"

    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
    expect(page).to have_content("Too Many Active Coupons. Set Status to 'deactivated.'")
  end
end
