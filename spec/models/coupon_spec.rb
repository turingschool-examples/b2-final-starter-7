require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do 
    @merchant = create(:merchant)
    @coupon_1 = @merchant.coupons.create!(name: '20%', unique_code: '20OFF', discount: 20, discount_type: 0)
    @coupon_2 = @merchant.coupons.create!(name: '50%', unique_code: '50OFF', discount: 50, discount_type: 1)
  end
  describe 'relationships' do 
    it {should belong_to :merchant}
    it {should have_many :invoices}
  end

  describe 'validations' do 
    it {should validate_uniqueness_of :unique_code} 
  end

  describe 'enums' do 
    it { should define_enum_for :status }
    it { should define_enum_for :discount_type }
  end
end
