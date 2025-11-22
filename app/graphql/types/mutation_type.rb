# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # ============================================================
    # FEATURE 2: Ticket Purchase with Availability
    # ============================================================
    field :purchase_tickets, mutation: Mutations::PurchaseTickets
  end
end
