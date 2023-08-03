require 'rails_helper'

describe Discount do
  describe "validations" do
    it { should validate_presence_of(:percentage) }
    it { should validate_presence_of(:threshold) }
    it { should validate_numericality_of(:percentage).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:threshold).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should belong_to(:merchant) }
  end
end