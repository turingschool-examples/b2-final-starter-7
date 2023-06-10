require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "Exsist" do
    it "exsists" do
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :kind }
    it { should validate_uniqueness_of :code }

    it { should belong_to :merchant }
    it { should have_many :invoices }
  end

  describe "Class methods" do
    before(:each) do
    @coupon1 = Coupon.create!(status: 1, code: "20off", name: "20 perc off", perc_disc: 20, dollar_disc: 0, kind: 0, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(status: 1, code: "10off", name: "10 dollers off", perc_disc: 0, dollar_disc: 10, kind: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create!(status: 1, code: "15off", name: "15 dollers off", perc_disc: 0, dollar_disc: 15, kind: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create!(status: 1, code: "25off", name: "25 dollers off", perc_disc: 0, dollar_disc: 25, kind: 1, merchant_id: @merchant1.id)
    @coupon5 = Coupon.create!(status: 0, code: "35off", name: "35 dollers off", perc_disc: 0, dollar_disc: 35, kind: 1, merchant_id: @merchant1.id)
    @coupon6 = Coupon.create!(status: 1, code: "100off", name: "100 dollers off", perc_disc: 0, dollar_disc: 100, kind: 1, merchant_id: @merchant2.id)
    end
  end
end
