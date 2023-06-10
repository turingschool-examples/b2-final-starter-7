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
    
    it 'coupon names are links to coupon show pages' do 
      visit(merchant_coupons_path(@dolly))

      within("#coupon-#{@coupon_1.id}") do 
        expect(page).to have_link("#{@coupon_1.name}", href: "merchants/#{@dolly.id}/coupons/#{@coupon_1.id}")
      end

      within("#coupon-#{@coupon_2.id}") do 
        expect(page).to have_link("#{@coupon_2.name}", href: "merchants/#{@dolly.id}/coupons/#{@coupon_2.id}")
      end
    end
  end
end