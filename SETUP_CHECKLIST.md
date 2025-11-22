# Setup Checklist for Evaluators

Before distributing this assessment to candidates, verify the following:

## Pre-Distribution Checklist

### 1. Environment Verification

- [ ] Rails loads without errors
  ```bash
  bundle exec rails runner "puts 'OK'"
  ```

- [ ] GraphQL schema is valid
  ```bash
  bundle exec rails runner "puts BackendTestSchema.to_definition.lines.first"
  ```

- [ ] Models are properly configured
  ```bash
  bundle exec rails runner "Event.new.class.name"
  ```

### 2. Docker Setup

- [ ] Docker Compose file is valid
  ```bash
  docker-compose config
  ```

- [ ] MongoDB Atlas Local image pulls correctly
  ```bash
  docker pull mongodb/mongodb-atlas-local
  ```

- [ ] Services start successfully
  ```bash
  docker-compose up -d
  docker-compose ps
  ```

- [ ] Rails can connect to MongoDB in Docker
  ```bash
  docker-compose exec rails bundle exec rails runner "Mongoid.default_client.command(ping: 1)"
  ```

### 3. Seed Data

- [ ] Seeds run without errors
  ```bash
  bundle exec rake db:seed
  # OR
  docker-compose exec rails bundle exec rake db:seed
  ```

- [ ] Expected data is created (1500 events)
  ```bash
  bundle exec rails runner "puts Event.count"
  # Should output: 1500
  ```

- [ ] Purchases are created
  ```bash
  bundle exec rails runner "puts Purchase.count"
  # Should output: ~4500
  ```

### 4. Tests Configuration

- [ ] RSpec is properly configured
  ```bash
  bundle exec rspec --dry-run
  ```

- [ ] All tests are pending/skipped (before implementation)
  ```bash
  bundle exec rspec
  # Should show: 0 failures, X pending
  ```

- [ ] FactoryBot works
  ```bash
  bundle exec rails runner "require 'factory_bot_rails'; FactoryBot.create(:event)"
  ```

### 5. Documentation Review

- [ ] README.md is clear and complete
- [ ] EVALUATOR_GUIDE.md rubric is up to date
- [ ] QUICKSTART.md time estimates are reasonable
- [ ] PROJECT_SUMMARY.md reflects current structure
- [ ] Example queries in README work

### 6. GraphQL Endpoint Testing

- [ ] Server starts without errors
  ```bash
  bundle exec rails server
  # Visit http://localhost:3000/graphql
  ```

- [ ] Test query works (expect NotImplementedError)
  ```graphql
  query {
    events {
      id
      name
    }
  }
  ```

- [ ] CORS is configured correctly
  ```bash
  curl -H "Origin: http://localhost:3001" \
       -H "Access-Control-Request-Method: POST" \
       -X OPTIONS http://localhost:3000/graphql -v
  # Should return Access-Control-Allow-Origin: *
  ```

### 7. Files to Review

- [ ] No sensitive data in repository (API keys, passwords)
- [ ] .gitignore is comprehensive
- [ ] No `.env` file committed (only `.env.example`)
- [ ] config/master.key is gitignored
- [ ] Gemfile.lock is present

### 8. Code Quality

- [ ] No syntax errors
  ```bash
  find app -name "*.rb" -exec ruby -c {} \;
  ```

- [ ] RuboCop passes (if configured)
  ```bash
  bundle exec rubocop
  ```

- [ ] All TODOs are intentional (for candidates)
  ```bash
  grep -r "TODO" app/
  ```

### 9. Instructions Clarity

- [ ] Time estimates are realistic (1 hour total)
- [ ] All file paths in README are correct
- [ ] Example GraphQL queries have correct field names
- [ ] Setup instructions work on both macOS and Linux
- [ ] Docker instructions are tested

### 10. Clean State

Before distributing:

- [ ] Drop and reseed database
  ```bash
  bundle exec rake db:drop db:seed
  ```

- [ ] Remove any test/debug code
- [ ] Clear logs
  ```bash
  rm -f log/*.log
  ```

- [ ] Remove tmp files
  ```bash
  rm -rf tmp/*
  ```

## Distribution Checklist

- [ ] Create clean git repository
  ```bash
  git init
  git add .
  git commit -m "Initial commit - Backend assessment"
  ```

- [ ] Remove .git if distributing as zip
  ```bash
  rm -rf .git
  ```

- [ ] Create archive (if needed)
  ```bash
  tar -czf backend-assessment.tar.gz backend-test/
  ```

- [ ] Verify archive extracts correctly

## Post-Distribution Support

### Common Candidate Issues

1. **"MongoDB won't connect"**
   - Check: Is MongoDB running?
   - Fix: `docker-compose up mongodb` or `brew services start mongodb-community`

2. **"Bundle install fails"**
   - Check: Ruby version (need 3.2+)
   - Fix: Use rbenv/rvm to install correct Ruby

3. **"No seed data"**
   - Fix: `bundle exec rake db:seed`

4. **"All tests fail"**
   - Explain: Tests are intentionally pending (xit) until features are implemented

5. **"GraphQL returns NotImplementedError"**
   - Explain: This is expected - candidates need to implement the features

### Expected Timeline

- **Setup:** 5 minutes
- **Feature 1:** 15-20 minutes
- **Feature 2:** 20-25 minutes
- **Feature 3:** 15-20 minutes
- **Testing/Cleanup:** Remaining time

## Evaluation Preparation

Before evaluating submissions:

- [ ] Watch screen recording first (30-40 min)
- [ ] Review code (20-30 min)
- [ ] Test their implementation (10-15 min)
- [ ] Use EVALUATOR_GUIDE.md rubric
- [ ] Test race condition handling specifically

### Testing Race Conditions

```ruby
# In rails console
event = Event.first
threads = 10.times.map do
  Thread.new do
    mutation = <<~GQL
      mutation {
        purchaseTickets(
          eventId: "#{event.id}",
          customerEmail: "test@example.com",
          customerName: "Test User",
          quantity: 1
        ) {
          purchase { id }
          errors
        }
      }
    GQL

    result = BackendTestSchema.execute(mutation)
    puts result.to_json
  end
end
threads.each(&:join)

event.reload
puts "Available tickets: #{event.available_tickets}"
# Should NEVER be negative!
```

## Version Information

- **Rails:** 8.0.2+
- **Ruby:** 3.2.9
- **MongoDB:** 6.0+ (Atlas Local)
- **GraphQL:** 2.5+
- **RSpec:** 7.1+
- **Mongoid:** 9.0+

## Maintenance Notes

### Updating Dependencies

```bash
bundle update --conservative
bundle exec rspec  # Ensure tests still work
```

### Regenerating Seeds

If you need to change seed data:
1. Edit `db/seeds.rb`
2. Test with `bundle exec rake db:drop db:seed`
3. Verify counts: `bundle exec rails runner "puts Event.count"`

### Adding New Test Cases

1. Add to appropriate spec file
2. Mark as pending with `xit` (not `it`)
3. Add comments explaining what candidates should test
4. Update EVALUATOR_GUIDE.md rubric if needed

## Contact

If you encounter issues with this assessment setup:
1. Check this checklist first
2. Review PROJECT_SUMMARY.md
3. Verify your environment matches requirements
4. Check for updates to dependencies

---

**Last Verified:** [Add date when last checked]
**Verified By:** [Add your name]
**Environment:** [macOS/Linux/Docker]
