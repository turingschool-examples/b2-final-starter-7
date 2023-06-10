require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "Exsist" do
    it "exists" do
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :kind}

    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
end
