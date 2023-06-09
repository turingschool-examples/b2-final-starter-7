require "rails_helper"

RSpec.describe Cupon, type: :model do
  describe "Exsist" do
    it "exists" do
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :percent_discount }
    it { should validate_presence_of :dollar_discount }
    it { should validate_presence_of :status }

    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
end
