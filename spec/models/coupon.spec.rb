require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unique_code }
    it { should validate_presence_of :percent_off }
  
  end
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices}

  end