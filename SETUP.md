## Setup (Choose one method)

### Docker (Easiest)
```bash
docker-compose up -d
docker-compose exec rails bundle exec rake db:seed
docker-compose exec rails ./bin/verify_setup
```

#### How to run specs:
```bash
docker-compose exec rails rspec spec
```

### Local
```bash
bundle install
# Start MongoDB (brew services start mongodb-community OR docker)
bundle exec rake db:seed
./bin/verify_setup
bundle exec rails server
```
