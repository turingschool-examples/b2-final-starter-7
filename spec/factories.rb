FactoryBot.define do
  factory :customer do
    first_name {Faker::JapaneseMedia::Naruto.character}
    last_name {Faker::JapaneseMedia::Naruto.eye}
  end

  factory :invoice do
    status {[0,1,2].sample}
    merchant
    customer
  end

  factory :merchant do
    name {Faker::Science.scientist}
    invoices
    items
  end

  factory :item do
    name {Faker::Games::Zelda.item}
    description {Faker::Hacker.say_something_smart}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    merchant
  end

  factory :transaction do
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    invoice
  end

  factory :invoice_item do
    status {[0,1,2].sample}
    merchant
    invoice
  end
end
