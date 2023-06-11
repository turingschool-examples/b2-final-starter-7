require 'rails_helper' 

RSpec.describe 'New Coupon Form', type: :feature do
  before :each do 
    @dolly = create(:merchant)
    @jermaine = create(:merchant)
    @coupon_1 = create(:coupon, merchant: @dolly)
    @coupon_2 = create(:coupon, merchant: @dolly)
  end

  describe 'Form works' do 
    it 'form can be filled in' do 
      visit new_merchant_coupon_path(@dolly)

      expect(page).to have_content("Create New Coupon")
      expect(page).to have_content('Name')
      expect(page).to have_content('Unique Code')
      expect(page).to have_content('Discount')
      expect(page).to have_content('Discount Type')
      expect(page).to have_content('Status')

      fill_in(:name, with: 'Ides of March')
      fill_in(:unique_code, with: 'IDES15')
      fill_in(:discount, with: 15)
      select 'Percentage', from: :discount_type
      select 'Inactive', from: :status
      click_button('Save')

      expect(current_path).to eq(merchant_coupons_path(@dolly))
      expect(@dolly.coupons.count).to eq(3)
    end

    it 'error if more than 5 active coupons created' do 
      coupon1 = create(:coupon, status: 1, merchant: @jermaine)
      coupon2 = create(:coupon, status: 1, merchant: @jermaine)
      coupon3 = create(:coupon, status: 1, merchant: @jermaine)
      coupon4 = create(:coupon, status: 1, merchant: @jermaine)
      coupon5 = create(:coupon, status: 1, merchant: @jermaine)

      visit new_merchant_coupon_path(@jermaine)

      fill_in(:name, with: 'Ides of March')
      fill_in(:unique_code, with: 'IDES15')
      fill_in(:discount, with: 15)
      select 'Percentage', from: :discount_type
      select 'Active', from: :status
      
      click_button('Save')
      expect(current_path).to eq(new_merchant_coupon_path(@jermaine))
      expect(page).to have_content("Coupon could not be saved because you have too many coupons active currently")
    end
  end
  
  # As a merchant
  # When I visit my coupon index page
  # I see a link to create a new coupon.
  # When I click that link
  # I am taken to a new page where I see a form to add a new coupon.
  # When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
  # And click the Submit button
  # I'm taken back to the coupon index page
  # And I can see my new coupon listed.
  
  # Sad Paths to consider:
  # This Merchant already has 5 active coupons
  # Coupon code entered is NOT unique
end