# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context

This is a **backend developer assessment** (not production code) - a 1-hour coding challenge designed to evaluate candidates' ability to build scalable GraphQL APIs with MongoDB, focusing on race condition handling and performance optimization.

**Critical Context:**
- Candidates are recorded while working and evaluated on their PROCESS, not just final code quality
- The assessment has intentional TODOs and NotImplementedError raises - these are for candidates to implement
- There are TWO types of documentation: candidate-facing (README.md, QUICKSTART.md) and evaluator-facing (EVALUATOR_GUIDE.md, SETUP_CHECKLIST.md)

## Development Commands

### Local Development (without Docker)
```bash
# Setup
bundle install
brew services start mongodb-community  # or use Docker MongoDB

# Database
bundle exec rake db:seed               # Seeds 1500 events + purchases
bundle exec rake db:drop               # Drop database
bundle exec rake db:reset              # Drop and reseed

# Run server
bundle exec rails server               # http://localhost:3000/graphql

# Testing
bundle exec rspec                      # Run all tests
bundle exec rspec spec/graphql/queries/events_query_spec.rb  # Specific file
bundle exec rspec --format documentation

# Verification
./bin/verify_setup                     # Checks Rails, MongoDB, GraphQL, seed data
```

### Docker Development
```bash
# Start services
docker-compose up -d                   # MongoDB + Rails in background
docker-compose up                      # With logs

# Database operations
docker-compose exec rails bundle exec rake db:seed
docker-compose exec rails bundle exec rake db:reset

# Testing
docker-compose exec rails bundle exec rspec

# Rails console
docker-compose exec rails bundle exec rails console

# View logs
docker-compose logs -f rails
docker-compose logs -f mongodb

# Stop services
docker-compose down
```

### Distribution
```bash
# Package for candidates (excludes EVALUATOR_GUIDE.md, SETUP_CHECKLIST.md)
./bin/package_for_candidates
```

## Architecture Overview

### Technology Stack
- **Framework:** Rails 8.0 (API-only, no ActiveRecord)
- **Database:** MongoDB via Mongoid 9.0 ODM
- **API:** GraphQL (graphql-ruby 2.5+)
- **Testing:** RSpec 7.1, FactoryBot, DatabaseCleaner
- **MongoDB Image:** MongoDB Atlas Local (via Docker)

### GraphQL Schema Structure

The GraphQL API is organized as:
- **Schema:** `app/graphql/backend_test_schema.rb` - Main schema with DataLoader enabled
- **Queries:** `app/graphql/types/query_type.rb` - Contains `events` and `popular_events` (intentionally not implemented)
- **Mutations:** `app/graphql/mutations/purchase_tickets.rb` - Contains ticket purchase logic (intentionally not implemented)
- **Types:** `app/graphql/types/` - EventType, PurchaseType, EventFilterInput
- **Endpoint:** `POST /graphql` via `app/controllers/graphql_controller.rb`

### Data Models

**Event Model** (`app/models/event.rb`):
- Fields: name, description, date, venue, city, category, total_tickets, available_tickets, price
- Relationship: `has_many :purchases`
- **Key TODO:** Candidates should add MongoDB indexes for filtering/performance

**Purchase Model** (`app/models/purchase.rb`):
- Fields: customer_email, customer_name, quantity, total_price
- Relationship: `belongs_to :event`
- **Key TODO:** Candidates should implement race condition handling

### Assessment Features (TODOs for Candidates)

**Feature 1: Event Listings** (`app/graphql/types/query_type.rb#events`)
- Implement filtering by category, city, date range
- Add pagination (offset or cursor-based)
- Requires MongoDB indexes for performance (1500+ events)

**Feature 2: Ticket Purchase** (`app/graphql/mutations/purchase_tickets.rb#resolve`) ⚠️ **MOST CRITICAL**
- Atomic ticket availability updates
- Race condition handling (concurrent purchases)
- Expected solution: MongoDB atomic operations (`find_and_modify` or transactions)
- Worth 40/105 points in evaluation

**Feature 3: Popular Events** (`app/graphql/types/query_type.rb#popular_events`)
- Rank events by purchases in last N days
- Performance-optimized for high scale
- Expected solution: MongoDB aggregation pipeline or pre-computed counters

### Testing Structure

Tests are **intentionally skipped** (`xit` instead of `it`) until candidates implement features:
- `spec/graphql/queries/events_query_spec.rb` - Tests for Feature 1
- `spec/graphql/mutations/purchase_tickets_spec.rb` - Tests for Feature 2 (includes critical race condition test)
- `spec/models/event_spec.rb` - Example model tests

### Database Configuration

MongoDB connection uses environment variables for Docker compatibility:
- `MONGODB_HOST` - defaults to 'localhost', set to 'mongodb' in Docker
- `MONGODB_PORT` - defaults to '27017'
- Configuration: `config/mongoid.yml`
- Docker uses MongoDB Atlas Local image for feature parity

### Seed Data (`db/seeds.rb`)

Creates realistic test data:
- 1500 events across 7 categories, 20 cities, next 180 days
- ~4500 purchases (30% of events have 1-20 purchases each, last 30 days)
- Designed to expose inefficient queries if candidates don't add indexes

## Working with This Codebase

### When Editing Candidate Documentation
Files candidates see:
- README.md - Main instructions with 3 feature requirements
- QUICKSTART.md - Fast reference
- GETTING_STARTED.md - Quick start guide
- PROJECT_SUMMARY.md - Technical overview
- DOCS_INDEX.md - Documentation map

**Important:** Maintain strong emphasis on screen recording requirement (NO RECORDING = REJECTION)

### When Editing Evaluator Documentation
Files evaluators see (excluded from candidate package):
- EVALUATOR_GUIDE.md - 105-point rubric, scoring guidelines
- SETUP_CHECKLIST.md - Pre-distribution verification

### Intentional NotImplementedErrors
The following are SUPPOSED to raise NotImplementedError - don't "fix" them:
- `app/graphql/types/query_type.rb#events`
- `app/graphql/types/query_type.rb#popular_events`
- `app/graphql/mutations/purchase_tickets.rb#resolve`

These are the features candidates implement during the assessment.

### Critical Race Condition Pattern

The correct solution for Feature 2 (ticket purchase) uses MongoDB atomic operations:

```ruby
# CORRECT - Atomic operation prevents race conditions
event = Event.collection.find_one_and_update(
  { _id: BSON::ObjectId(event_id), available_tickets: { '$gte': quantity } },
  { '$inc': { available_tickets: -quantity } },
  return_document: :after
)

# WRONG - Race condition possible
event = Event.find(event_id)
if event.available_tickets >= quantity
  event.update(available_tickets: event.available_tickets - quantity)  # ⚠️ RACE CONDITION
end
```

This is the most important evaluation criterion (15/40 points for Feature 2).

### GraphQL Testing Pattern

Tests use direct schema execution:
```ruby
query = <<~GQL
  query {
    events(filters: { category: "concert" }) {
      id
      name
    }
  }
GQL

post '/graphql', params: { query: query }
json = JSON.parse(response.body)
```

### MongoDB Indexing

Candidates should add indexes for filtered fields:
```ruby
# In app/models/event.rb
index({ category: 1, city: 1, date: 1 })  # Compound index for common filters
```

## Key Constraints

1. **This is assessment code** - Don't refactor away the intentional TODOs or incomplete implementations
2. **No ActiveRecord** - Uses Mongoid ODM exclusively
3. **API-only Rails** - No views, assets, or frontend
4. **Recording is mandatory** - All documentation emphasizes this heavily
5. **Time-boxed** - Designed to be completed in 1 hour
6. **Evaluator files are separate** - Use `./bin/package_for_candidates` to create candidate package

## Common Pitfalls to Avoid

When maintaining this assessment:
- Don't implement the TODO features (they're for candidates)
- Don't add production environment files (removed intentionally)
- Don't modify the intentional NotImplementedErrors
- Keep evaluator files separate from candidate files
- Maintain emphasis on recording requirement in all docs
- Don't change the 3-feature structure or time allocations
