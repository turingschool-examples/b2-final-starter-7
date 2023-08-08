require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'Associations' do
    it { should belong_to :merchant }
    it { should have_many :items }
  end

  describe 'Validations' do
    it { should validate_presence_of :percent_discount }
    it { should validate_presence_of :threshold_quantity }
  end
end