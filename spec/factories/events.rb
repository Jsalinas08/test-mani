FactoryBot.define do
  factory :event do
    name { Faker::Music.band }
    description { Faker::Lorem.paragraph }
    date { Faker::Time.forward(days: 60) }
    venue { Faker::Address.community }
    city { Faker::Address.city }
    category { %w[concert sports theater conference].sample }
    total_tickets { 1000 }
    available_tickets { 1000 }
    price { Faker::Commerce.price(range: 20.0..200.0) }
  end
end
