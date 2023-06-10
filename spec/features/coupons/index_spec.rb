require 'rails_helper' 

RSpec.describe 'Coupons Index', type: :feature do
  before :each do 
    @dolly = create(:merchant)
    @coupon_1 = create(:coupon, merchant: @dolly)
    @coupon_2 = create(:coupon, merchant: @dolly)
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
        expect(page).to have_link("#{@coupon_1.name}", href: merchant_coupon_path(@dolly, @coupon_1))
        click_link("#{@coupon_1.name}")
        expect(current_path).to eq(merchant_coupon_path(@dolly, @coupon_1))
      end

      # within("#coupon-#{@coupon_2.id}") do  
      #   expect(page).to have_link("#{@coupon_2.name}", href: merchant_coupon_path(@dolly, @coupon_2))
      #   click_link("#{@coupon_2.name}")
      #   expect(current_path).to eq(merchant_coupon_path(@dolly, @coupon_2))
      # end
    end

    it 'has link to coupon create page' do 
      visit (merchant_coupons_path(@dolly))

      expect(page).to have_link('Create a New Coupon', href: new_merchant_coupon_path(@dolly))
      click_link('Create a New Coupon')
      expect(current_path).to eq(new_merchant_coupon_path(@dolly))
    end
  end
end