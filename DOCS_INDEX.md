# Documentation Index

This assessment includes multiple documentation files. Use this index to find the information you need.

## For Candidates

### Primary Documents

1. **[README.md](README.md)** - START HERE
   - Complete assessment instructions
   - Setup guide (local + Docker)
   - Feature requirements (all 3 features)
   - Example GraphQL queries
   - Tips and common pitfalls
   - **Read time:** 10-15 minutes

2. **[QUICKSTART.md](SETUP.md)** - Fast Reference
   - Quick setup commands
   - Feature checklist
   - Time management guide
   - One-page reference
   - **Read time:** 2-3 minutes

### Reference Documents

3. **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Technical Overview
   - Project structure
   - Database schema
   - Technology stack
   - Common solutions
   - **Read time:** 5 minutes

## For Evaluators/Correctors

### Evaluation Documents

4. **[EVALUATOR_GUIDE.md](EVALUATOR_GUIDE.md)** - ESSENTIAL FOR GRADING
   - Complete scoring rubric (100 points)
   - Feature-by-feature evaluation criteria
   - Example excellent solutions
   - Red flags to watch for
   - Interview follow-up questions
   - **Read time:** 20 minutes
   - **Use during:** Code review and grading

5. **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Pre-Distribution Verification
   - Step-by-step verification
   - Environment testing commands
   - Common candidate issues
   - Distribution checklist
   - **Use before:** Sending to candidates

## Quick Reference by Role

### I'm a Candidate
**Start here:**
1. Read [README.md](README.md) - Full requirements
2. Keep [QUICKSTART.md](SETUP.md) open - Fast reference during coding
3. Refer to [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - If you need technical details

**Time investment:** 15-20 minutes of reading before starting

### I'm an Evaluator
**Start here:**
1. Review [EVALUATOR_GUIDE.md](EVALUATOR_GUIDE.md) - Understand scoring
2. Use [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Verify before distribution
3. Refer to [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Technical reference

**Time investment:** 30 minutes to understand assessment

### I'm Maintaining This Assessment
**Start here:**
1. Read [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Understand architecture
2. Check [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Verify changes work
3. Update [EVALUATOR_GUIDE.md](EVALUATOR_GUIDE.md) - If rubric changes

## Document Purposes at a Glance

| Document | Audience | Purpose | Length |
|----------|----------|---------|--------|
| README.md | Candidates | Complete instructions | Long |
| QUICKSTART.md | Candidates | Fast reference | Short |
| PROJECT_SUMMARY.md | Everyone | Technical overview | Medium |
| EVALUATOR_GUIDE.md | Evaluators | Grading rubric | Long |
| SETUP_CHECKLIST.md | Evaluators | Pre-flight check | Medium |
| DOCS_INDEX.md | Everyone | Navigation | Short |

## Configuration Files

### Essential Files
- **Gemfile** - Ruby dependencies
- **docker-compose.yml** - Container orchestration
- **config/mongoid.yml** - MongoDB configuration
- **.env.example** - Environment variable template

### Setup Files
- **db/seeds.rb** - Database seed data (1500 events)
- **bin/verify_setup** - Setup verification script
- **.ruby-version** - Ruby version specification

## Common Questions & Relevant Docs

**"How do I set up the project?"**
→ [README.md](README.md) - Setup Instructions section

**"What features do I need to implement?"**
→ [README.md](README.md) - The Challenge section
→ [QUICKSTART.md](SETUP.md) - Quick task list

**"How will I be evaluated?"**
→ [EVALUATOR_GUIDE.md](EVALUATOR_GUIDE.md) - Scoring Rubric

**"What's the project structure?"**
→ [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project Structure section

**"What database schema should I use?"**
→ [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Database Schema section

**"How do I verify my setup is correct?"**
→ Run `./bin/verify_setup`
→ [README.md](README.md) - Verify setup step

**"What are common solutions for the features?"**
→ [EVALUATOR_GUIDE.md](EVALUATOR_GUIDE.md) - Common Excellent Solutions
→ [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Common Solutions

**"How much time should I spend on each feature?"**
→ [README.md](README.md) - Time Management Suggestions
→ [QUICKSTART.md](SETUP.md) - Time allocations

**"What if I encounter issues during setup?"**
→ [README.md](README.md) - Questions? section
→ [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Common Candidate Issues

## File Locations for Implementation

### Candidates Need to Edit:
- `app/graphql/types/query_type.rb` (Features 1 & 3)
- `app/graphql/mutations/purchase_tickets.rb` (Feature 2)
- `app/models/event.rb` (Add indexes)
- `spec/graphql/**/*_spec.rb` (Uncomment tests)

### Candidates Should Not Edit:
- GraphQL type definitions
- Configuration files
- Docker setup
- Seeds

See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for complete file structure.

## Documentation Maintenance

When updating this assessment:

1. **Add/change features:** Update README.md, EVALUATOR_GUIDE.md, QUICKSTART.md
2. **Change tech stack:** Update PROJECT_SUMMARY.md, README.md
3. **Modify scoring:** Update EVALUATOR_GUIDE.md
4. **Add setup steps:** Update SETUP_CHECKLIST.md, README.md
5. **Update this index:** Add new docs to this file

## Version History

- **v1.0** - Initial assessment creation
  - 3 features (Event Listings, Ticket Purchase, Popular Events)
  - MongoDB + GraphQL + Rails
  - Docker setup with MongoDB Atlas Local
  - Comprehensive documentation suite

---

**Need help navigating?** Start with the role-based quick reference above.
