require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :merchant_id }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "instance methods" do
    describe "#multiplier" do
      it "converts percentage discount into the percentage of the original price the customer will owe" do
      merchant1 = Merchant.create!(name: 'Merchant 1')
      discount_1 = merchant1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10)
      discount_2 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
      discount_3 = merchant1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 25)

      expect(discount_1.multiplier).to eq(0.90)
      expect(discount_2.multiplier).to eq(0.80)
      expect(discount_3.multiplier).to eq(0.70)
      end
    end
  end
end