require "rails_helper"

describe "merchant coupon show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon1 = Coupon.create!(status: 1, code: "20off", name: "20 perc off", perc_disc: 20, dollar_disc: 0, kind: 0, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(status: 1, code: "10off", name: "10 dollers off", perc_disc: 0, dollar_disc: 10, kind: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create!(status: 1, code: "15off", name: "15 dollers off", perc_disc: 0, dollar_disc: 15, kind: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create!(status: 1, code: "25off", name: "25 dollers off", perc_disc: 0, dollar_disc: 25, kind: 1, merchant_id: @merchant1.id)
    @coupon5 = Coupon.create!(status: 0, code: "35off", name: "35 dollers off", perc_disc: 0, dollar_disc: 35, kind: 1, merchant_id: @merchant1.id)

    @merchant2 = Merchant.create!(name: "Jewelry")
    @coupon6 = Coupon.create!(status: 1, code: "100off", name: "100 dollers off", perc_disc: 0, dollar_disc: 100, kind: 1, merchant_id: @merchant2.id)

    visit merchant_coupon_path(@merchant1, @coupon1)
  end
  # And I see a count of how many times that coupon has been used.
  # (Note: "use" of a coupon should be limited to successful transactions.)
  it "shows name of code" do
    save_and_open_page
    expect(page).to have_content(@coupon1.name)
  end

  it "shows the percent/dollar off value" do
    expect(page).to have_content(@coupon1.perc_disc)
  end

  it "shows status (active or inactive)" do
    expect(page).to have_content(@coupon1.status)
  end

  xit "shows how many times the coupon has been used" do

  end
end

