require 'rails_helper' 

RSpec.describe 'Coupons Index', type: :feature do
  before :each do 
    @dolly = create(:merchant)
    @coupon_1 = @dolly.coupons.create!(name: 'Labor Day', unique_code: '20OFF', discount: 20, discount_type: 0)
    @coupon_2 = @dolly.coupons.create!(name: 'Memorial Day', unique_code: '50OFF', discount: 50, discount_type: 1)
  end

  describe 'merchant coupons' do 
    it 'lists coupon names and amount off' do 
      visit(merchant_coupons_path(@dolly))

      within("#coupons") do 
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.discount)
        expect(page).to have_content(@coupon_2.name)
        expect(page).to have_content(@coupon_1.discount)
      end
    end
  end
end