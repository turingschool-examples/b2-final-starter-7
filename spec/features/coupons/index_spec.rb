require 'rails_helper' 

RSpec.describe 'Coupons Index', type: :feature do
  before :each do 
    @dolly = create(:merchant)
    @coupon_1 = @dolly.coupons.create!(name: 'Labor Day', unique_code: '20OFF', percent_discount: 20, dollar_discount: nil)
    @coupon_2 = @dolly.coupons.create!(name: 'Memorial Day', unique_code: '50OFF', percent_discount: 50, dollar_discount: nil)
  end

  describe 'merchant coupons' do 
    it 'lists coupon names and amount off' do 
      visit(merchant_coupons_path(@dolly))

      within("#coupons") do 
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.percent_discount)
        expect(page).to have_content(@coupon_2.name)
        expect(page).to have_content(@coupon_1.percent_discount)
      end
    end
  end
end