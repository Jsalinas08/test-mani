# Backend Developer Assessment - Event Ticketing API

Welcome! This is a technical assessment designed to evaluate your backend development skills, particularly your ability to build scalable GraphQL APIs with MongoDB.

## Assessment Overview

**Time Limit:** 1 hour
**Tech Stack:** Ruby on Rails, MongoDB (Mongoid), GraphQL
**AI Tools:** You SHOULD use AI assistance, claude code or whatever tool you prefer. 
We want to see how you leverage AI effectively in your workflow. 

USE 'QUICKSTART.md' TO MAKE SURE YOU HAVE EVERYTHING SET UP CORRECTLY BEFORE STARTING THE RECORDING.

---

## ⚠️ RECORDING IS MANDATORY - READ THIS FIRST ⚠️

### YOU MUST RECORD YOUR SCREEN

**NO RECORDING = NO EVALUATION** - Your submission will be automatically rejected without review.

**IMPORTANT:**
- ✅ **Start recording BEFORE you begin** (before reading requirements or writing any code)
- ✅ **Record your ENTIRE session** (setup, coding, testing, debugging - everything)
- ✅ **Screen recording only** - Audio is optional but encouraged
- ✅ **Show your REAL work process** - We want authenticity, not perfection
- ✅ **Don't edit the recording** - Keep all mistakes, bugs, and problem-solving

**What we want to see:**
- How you leverage AI tools in real-time.
- How you actually work on a daily basis
- Your thinking process when facing problems
- How you use documentation, Google, AI tools
- How you debug and fix issues
- Your real decision-making process
- How you handle uncertainty and mistakes

---

## What We're Evaluating

Based on your recording and code, we want to see:
- Your AI tool usage and integration into your workflow
- Your thought process and problem-solving approach
- How you handle scalability concerns
- Your understanding of race conditions and data consistency
- Code quality and testing practices
- How you leverage AI tools effectively (and verify their output)
- **How you actually work** - your real methodology

## The Challenge

You'll implement 3 features for an event ticketing system, each building on the previous one and increasing in complexity:

### Feature 1: Event Listings with Filtering (15-20 min)
**Difficulty:** Basic
**Location:** `app/graphql/types/query_type.rb` → `events` query

Implement a GraphQL query that returns a paginated list of events with filtering support.

**Requirements:**
- Support filtering by: `category`, `city`, `date_from`, `date_to`
- Implement pagination (offset-based is fine, but cursor-based is better)
- Handle the dataset efficiently (1500+ events in the database)

**Key Questions to Consider:**
- What MongoDB indexes do you need for optimal performance?
- How do you ensure queries remain fast with large datasets?

**Testing:** Uncomment and run the tests in `spec/graphql/queries/events_query_spec.rb`

---

### Feature 2: Ticket Purchase with Availability (20-25 min)
**Difficulty:** Medium
**Location:** `app/graphql/mutations/purchase_tickets.rb` → `resolve` method

Implement a GraphQL mutation to purchase tickets with proper availability checking.

**Requirements:**
- Validate that enough tickets are available before purchase
- Update `available_tickets` atomically
- **Handle race conditions when multiple users buy simultaneously**
- Return appropriate errors on failure

**Critical Scalability Challenge:**
What happens if 100 users try to buy the last ticket at the same time? Your solution MUST prevent overbooking.

**Key Questions to Consider:**
- Should you use MongoDB transactions?
- How do you test for race conditions?

**Testing:** Uncomment tests in `spec/graphql/mutations/purchase_tickets_spec.rb`
**Extra Credit:** Write a test that simulates concurrent purchases using threads

---

### Feature 3: Popular Events Ranking (15-20 min)
**Difficulty:** Advanced
**Location:** `app/graphql/types/query_type.rb` → `popular_events` query

Implement a query that returns "trending" events based on recent purchase activity.

**Requirements:**
- Rank events by number of purchases in the last N days (default: 7)
- Return only top N events (default: 10)
- Ensure the query performs well at scale (more than 10k requests/sec)

**Key Questions to Consider:**
- No hints here

**Testing:** Write your own tests for this feature

---

## Setup Instructions

### Prerequisites
- Ruby 3.3+
- MongoDB 6.0+
- Bundler

**OR**

- Docker & Docker Compose (recommended for consistent environment)

### Installation

#### Option 1: Using Docker (Recommended)

1. **Start all services:**
   ```bash
   docker-compose up
   ```
   This will start both MongoDB and the Rails server.

2. **Seed the database (in a new terminal):**
   ```bash
   docker-compose exec rails bundle exec rake db:seed
   ```

3. **Verify setup:**
   Visit `http://localhost:3000/graphql`

4. **Run tests:**
   ```bash
   docker-compose exec rails bundle exec rspec
   ```

#### Option 2: Local Installation

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Start MongoDB:**
   ```bash
   # If using Homebrew on macOS
   brew services start mongodb-community

   # Or using Docker (MongoDB Atlas Local)
   docker run -d -p 27017:27017 --name mongodb \
     -v mongodb_data:/data/db \
     -v mongodb_config:/data/configdb \
     mongodb/mongodb-atlas-local
   ```

3. **Seed the database:**
   ```bash
   bundle exec rake db:seed
   ```
   This creates 1500 events and sample purchase data.

4. **Start the server:**
   ```bash
   bundle exec rails server
   ```

5. **Verify setup:**
   ```bash
   ./bin/verify_setup
   ```
   This will check that everything is configured correctly.

   Then visit `http://localhost:3000/graphql` or use a GraphQL client

6.  **Usefull commands if something not working**
   ```bash
    docker-compose -f docker-compose.yml down -v
    docker-compose -f docker-compose.yml up -d
   ```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/graphql/queries/events_query_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## GraphQL Endpoint

**URL:** `POST http://localhost:3000/graphql`

### Example Queries

#### Query Events (after implementing Feature 1)
```graphql
query {
  events(
    filters: {
      category: "concert",
      city: "New York",
      dateFrom: "2025-01-01T00:00:00Z"
    },
    limit: 20,
    offset: 0
  ) {
    id
    name
    date
    city
    category
    availableTickets
    price
  }
}
```

#### Purchase Tickets (after implementing Feature 2)
```graphql
mutation {
  purchaseTickets(
    eventId: "507f1f77bcf86cd799439011",
    customerEmail: "customer@example.com",
    customerName: "John Doe",
    quantity: 2
  ) {
    purchase {
      id
      quantity
      totalPrice
      event {
        name
        availableTickets
      }
    }
    errors
  }
}
```

#### Popular Events (after implementing Feature 3)
```graphql
query {
  popularEvents(limit: 10, days: 7) {
    id
    name
    city
    date
    purchasesCount
  }
}
```

## Models Reference

### Event
- `name` (String)
- `description` (String)
- `date` (DateTime)
- `venue` (String)
- `city` (String)
- `category` (String)
- `total_tickets` (Integer)
- `available_tickets` (Integer)
- `price` (Float)

### Purchase
- `event` (belongs_to Event)
- `customer_email` (String)
- `customer_name` (String)
- `quantity` (Integer)
- `total_price` (Float)

## Time Management Suggestions

- **Feature 1:** 15-20 minutes
- **Feature 2:** 20-25 minutes (this is the most critical!)
- **Feature 3:** 15-20 minutes
- **Testing & Refinement:** Remaining time

## Questions?

If you encounter setup issues or have questions about requirements, please ask! We want to evaluate your problem-solving, not your ability to debug environment issues.

## After Completion

### Submission Checklist

Please submit the following (ALL are required):

1. ✅ **Screen recording** (MANDATORY - we will NOT evaluate without it)
   - Must show the entire coding session
   - Format: MP4, MOV, or similar (ensure it's playable)
   - Upload to Google Drive, Dropbox, or similar
   - Audio is optional but encouraged

2. ✅ **Code repository**
   - Git repository with your implementation
   - Commit however you prefer (squashing is fine)

3. ✅ **Verify before submitting:**
   - Recording plays correctly
   - Recording shows your entire session (not edited)
   - Code runs without errors
   - Tests can be executed

**⚠️ IMPORTANT:** Without a complete recording showing your work process, your submission will be rejected regardless of code quality.

---

Good luck! We're excited to see **how you work** and your approach to solving these problems. Remember: authenticity over perfection!
