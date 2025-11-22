namespace :db do
  desc "Load seed data into MongoDB"
  task seed: :environment do
    load Rails.root.join('db/seeds.rb')
  end

  desc "Drop MongoDB database"
  task drop: :environment do
    Mongoid.purge!
    puts "MongoDB database dropped!"
  end

  desc "Drop and reseed the database"
  task reset: [:drop, :seed]
end
