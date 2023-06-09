require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "Exsist" do
    it "exists" do
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :percent_disc }
    it { should validate_presence_of :dollar_disc }
    it { should validate_presence_of :status }
    it { should validate_presence_of :type}

    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
end
