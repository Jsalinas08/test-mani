FactoryBot.define do
  factory :purchase do
    association :event
    customer_email { Faker::Internet.email }
    customer_name { Faker::Name.name }
    quantity { rand(1..5) }
    total_price { quantity * event.price }
  end
end
