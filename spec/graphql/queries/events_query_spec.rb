require 'rails_helper'

RSpec.describe 'Events Query', type: :request do
  describe 'events query' do
    # TODO: This test will fail until candidates implement the query
    # This is intentional - it shows candidates what they need to implement

    it 'returns a list of events' do
      # Create test data
      create_list(:event, 5)

      query = <<~GQL
        query {
          events {
            id
            name
            city
            category
          }
        }
      GQL

      post '/graphql', params: { query: query }

      json = JSON.parse(response.body)
      data = json['data']['events']

      expect(data.length).to eq(5)
    end

    it 'filters events by category' do
      create(:event, category: 'concert')
      create(:event, category: 'sports')

      query = <<~GQL
        query {
          events(filters: { category: "concert" }) {
            id
            category
          }
        }
      GQL

      post '/graphql', params: { query: query }

      json = JSON.parse(response.body)
      data = json['data']['events']

      expect(data.length).to eq(1)
      expect(data.first['category']).to eq('concert')
    end

    # TODO: Candidates should add more tests:
    # - Test pagination
    # - Test date range filtering
    # - Test city filtering
    # - Test performance with large datasets
  end
end
