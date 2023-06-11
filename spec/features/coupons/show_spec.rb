# As a merchant
# When I visit a merchant's coupon show page
# I see that coupon's name and code
# And I see the percent/dollar off value
# As well as its status (active or inactive)
# And I see a count of how many times that coupon has been used.

# (Note: "use" of a coupon should be limited to successful transactions.)

require 'rails_helper'

RSpec.describe 'Show PAge' do
  before(:each) do 
    @dolly = create(:merchant)
    @coupon_1 = create(:coupon, merchant: @dolly)
    @coupon_2 = create(:coupon, merchant: @dolly)
  end

  describe 'coupon stats' do 
    it 'displays name, code, value and status' do 
      visit merchant_coupon_path(@dolly, @coupon1)
      expect(page).to have_content(@coupon1.name)
      expect(page).to have_content("Unique Code: #{@coupon1.code}")
      expect(page).to have_content("Amount off: #{@coupon1.value}")
      expect(page).to have_content("Status: #{@coupon1.status}")
    end
  end
end