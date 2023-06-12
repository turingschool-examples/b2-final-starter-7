FactoryBot.define do
  factory :coupon do
    name { Faker::App.name }
    unique_code { Faker::Commerce.promotion_code }
    status { Faker::Number.within(range: 0..1) } 
    discount { Faker::Number.decimal(l_digits: 2) }
    discount_type { Faker::Number.within(range: 0..1) } 
    :merchant
    :invoice
  end

  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
  end

  factory :invoice do
    status {[0,1,2].sample}
    :merchant
    :customer
  end

  factory :merchant do
    name {Faker::Space.galaxy}
  end

  factory :item do
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    :merchant
  end

  factory :transaction do
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    :invoice
  end

  factory :invoice_item do
    status {[0,1,2].sample}
    :merchant
    :invoice
  end
end
