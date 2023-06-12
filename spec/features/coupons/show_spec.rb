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
    @coupon_1 = create(:coupon, merchant: @dolly, status: 1)
    @coupon_2 = create(:coupon, merchant: @dolly)

    #times used set up
    @merchant = create(:merchant)
    @customer = create(:customer)
    @coupon = create(:coupon, merchant: @merchant)
    @invoice = create(:invoice, coupon: @coupon, customer: @customer)
    @invoice_2 = create(:invoice, coupon: @coupon, customer: @customer)
    @invoice_3 = create(:invoice, coupon: @coupon, customer: @customer)
    @transaction_1 = create(:transaction, invoice: @invoice, result: 1)
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 1)
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 0)
    
    visit merchant_coupon_path(@dolly, @coupon_1)
  end

  describe 'coupon stats' do 
    it 'displays name, code, value and status' do 
      expect(page).to have_content(@coupon_1.name)
      expect(page).to have_content("Unique Code: #{@coupon_1.unique_code}")
      expect(page).to have_content("Discount: #{@coupon_1.discount}")
      expect(page).to have_content("Status: #{@coupon_1.status}")
    end
    
    it 'displays times used' do 
      expect(page).to have_content("Times Used: #{@coupon_1.times_used}")
    end
    
    it 'for sure displays times used' do 
      visit merchant_coupon_path(@merchant, @coupon)
      expect(page).to have_content("Times Used: 2")
    end 
  end

  describe 'Merchant Coupon Deactivate' do 
    it 'has a button to deactivate coupon' do 
      visit merchant_coupon_path(@dolly, @coupon_1) 
      expect(page).to have_button('Deactivate')
    end

    it 'deactivate button updates status, redirect to show page, status is updated' do 
      visit merchant_coupon_path(@dolly, @coupon_1) 
      expect(@coupon_1.status).to eq('Active')
      expect(page).to have_content("Status: Active")
      click_button('Deactivate')
      expect(current_path).to eq(merchant_coupon_path(@dolly, @coupon_1))
      expect(@coupon_1.status).to eq('Inctive')
      expect(page).to have_content("Status: Inactive")
    end
  end
end

# As a merchant
# When I visit one of my active coupon's show pages
# I see a button to deactivate that coupon
# When I click that button
# I'm taken back to the coupon show page
# And I can see that its status is now listed as 'inactive'.

# Sad Paths to consider:
# A coupon cannot be deactivated if there are any pending invoices with that coupon.