require 'faker'

puts "Clearing existing data..."
Event.delete_all
Purchase.delete_all

puts "Creating 1500 events..."

# Categories for events
categories = %w[concert sports theater conference workshop festival comedy]
cities = [
  'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
  'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose',
  'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte',
  'San Francisco', 'Indianapolis', 'Seattle', 'Denver', 'Boston'
]

events = []

1500.times do |i|
  event = Event.create!(
    name: "#{Faker::Music.band} - #{Faker::Book.title}",
    description: Faker::Lorem.paragraph(sentence_count: 3),
    date: Faker::Time.forward(days: 180, period: :all),
    venue: Faker::Address.community,
    city: cities.sample,
    category: categories.sample,
    total_tickets: [100, 500, 1000, 2000, 5000].sample,
    available_tickets: rand(0..1000), # Some events may be sold out
    price: Faker::Commerce.price(range: 15.0..250.0)
  )
  events << event

  print "." if (i + 1) % 100 == 0
end

puts "\n#{Event.count} events created!"

puts "Creating sample purchases for popular events..."

# Create purchases for about 30% of events to simulate popularity
sample_events = events.sample(450)

purchase_count = 0
sample_events.each do |event|
  # Create 1-20 purchases per event
  rand(1..20).times do
    quantity = rand(1..5)
    Purchase.create!(
      event: event,
      customer_email: Faker::Internet.email,
      customer_name: Faker::Name.name,
      quantity: quantity,
      total_price: quantity * event.price,
      created_at: Faker::Time.backward(days: 30) # Purchases in last 30 days
    )
    purchase_count += 1
  end
end

puts "#{purchase_count} purchases created!"

puts "\n" + "=" * 60
puts "SEED DATA SUMMARY"
puts "=" * 60
puts "Total Events: #{Event.count}"
puts "Total Purchases: #{Purchase.count}"
puts "Events by category:"
Event.collection.aggregate([
  { '$group': { _id: '$category', count: { '$sum': 1 } } },
  { '$sort': { count: -1 } }
]).each do |result|
  puts "  #{result['_id']}: #{result['count']}"
end
puts "\nEvents by city (top 10):"
Event.collection.aggregate([
  { '$group': { _id: '$city', count: { '$sum': 1 } } },
  { '$sort': { count: -1 } },
  { '$limit': 10 }
]).each do |result|
  puts "  #{result['_id']}: #{result['count']}"
end
puts "=" * 60

puts "\n✓ Seeding complete!"
puts "\nNOTE FOR CANDIDATES:"
puts "- This dataset has 1500+ events to test query performance"
puts "- Some events have different availability (0 to 1000 tickets)"
puts "- Purchases are distributed across ~30% of events"
puts "- Consider indexing strategies for optimal query performance"
