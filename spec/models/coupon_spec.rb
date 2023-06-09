require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do 
    @merchant = create(:merchant)
    @coupon_1 = @merchant.coupons.create!(name: '20%', unique_code: '20OFF', percent_discount: 20, dollar_discount: nil)
    @coupon_2 = @merchant.coupons.create!(name: '50%', unique_code: '50OFF', percent_discount: 50, dollar_discount: nil)
  end
  describe 'relationships' do 
    it {should belong_to :merchant}
    it {should belong_to(:invoice).optional }
  end

  describe 'validations' do 
    it {should validate_uniqueness_of :unique_code} 
  end

  describe 'enum' do 
    it { should define_enum_for :status }
  end
end
