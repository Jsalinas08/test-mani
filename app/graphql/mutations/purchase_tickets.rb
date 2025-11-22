module Mutations
  class PurchaseTickets < BaseMutation
    description "Purchase tickets for an event"

    # Input fields
    argument :event_id, ID, required: true
    argument :customer_email, String, required: true
    argument :customer_name, String, required: true
    argument :quantity, Integer, required: true

    # Return fields
    field :purchase, Types::PurchaseType, null: true
    field :errors, [String], null: false

    # ============================================================
    # FEATURE 2: Ticket Purchase with Availability
    # ============================================================
    # TODO: Implement this mutation to handle ticket purchases
    # Requirements:
    # - Check if enough tickets are available before purchase
    # - Update the event's available_tickets atomically
    # - Handle the race condition when multiple users buy simultaneously
    # - Return appropriate errors if purchase fails
    #
    # Critical Questions to Consider:
    # - What happens if 2 users try to buy the last ticket at the same time?
    # - Should you use MongoDB transactions?
    # - Can you use atomic operators like $inc?
    # - How do you ensure data consistency?
    def resolve(event_id:, customer_email:, customer_name:, quantity:)
      # TODO: Implement purchase logic here
      # This is the MOST CRITICAL feature for testing race condition handling!

      { purchase: nil, errors: [] }
    end
  end
end
