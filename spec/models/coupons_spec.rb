require 'rails_helper'

describe Coupon do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :coupon_code }
    it { should validate_presence_of :discount_amount }
    it { should validate_presence_of :discount_type }
    it { should validate_presence_of :merchant_id }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to(:invoice).optional }
  end
end