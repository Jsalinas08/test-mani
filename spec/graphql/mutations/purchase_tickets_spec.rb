require 'rails_helper'

RSpec.describe 'PurchaseTickets Mutation', type: :request do
  describe 'purchaseTickets mutation' do
    let(:event) { create(:event, available_tickets: 100) }

    # TODO: This test will fail until candidates implement the mutation
    # This is intentional - it shows candidates what they need to implement

    it 'successfully purchases tickets' do
      mutation = <<~GQL
        mutation {
          purchaseTickets(input: {
            eventId: "#{event.id}",
            customerEmail: "test@example.com",
            customerName: "John Doe",
            quantity: 2
          }) {
            purchase {
              id
              quantity
              customerEmail
            }
            errors
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body)
      data = json['data']['purchaseTickets']

      expect(data['errors']).to be_empty
      expect(data['purchase']).not_to be_nil
      expect(data['purchase']['quantity']).to eq(2)
      expect(data['purchase']['customerEmail']).to eq('test@example.com')

      # Verify tickets were decremented
      event.reload
      expect(event.available_tickets).to eq(98)
    end

    it 'returns error when not enough tickets available' do
      mutation = <<~GQL
        mutation {
          purchaseTickets(input: {
            eventId: "#{event.id}",
            customerEmail: "test@example.com",
            customerName: "John Doe",
            quantity: 101
          }) {
            purchase {
              id
            }
            errors
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body)
      data = json['data']['purchaseTickets']

      expect(data['purchase']).to be_nil
      expect(data['errors']).not_to be_empty
    end

    # TODO: Candidates MUST add this critical test:
    # Test concurrent purchases (race condition)
    # Hint: Use threads to simulate multiple simultaneous purchases
    # This is the MOST IMPORTANT test for this feature!
    it 'handles concurrent purchases correctly' do
      # Create threads that simultaneously try to purchase tickets
      # Verify that no overbooking occurs
      # This tests the race condition handling
    end
  end
end
