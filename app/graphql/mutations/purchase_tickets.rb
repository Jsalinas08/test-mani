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
      event_dao = EventDao.new(model: Event)
      # Operación ATÓMICA: busca Y actualiza en una sola operación
      event = event_dao.event_resolver(event_id, quantity)

      # Si event es nil, no había tickets o el evento no existe
      return errors_purchase(
        ["No hay suficientes tickets disponibles o el evento no existe"]
      ) if event.nil?

      # Crear la compra
      event_obj = event_dao.find(event_id)
      purchase = PurchaseDao.new(model: Purchase).create_purchase(
        event_obj:,
        customer_email:,
        customer_name:,
        quantity:
      )

      { purchase: purchase, errors: [] }
    rescue Mongoid::Errors::DocumentNotFound
      errors_purchase(["Evento no encontrado"])
    rescue StandardError => e
      errors_purchase(["Error interno: #{e.message}"])
    end

    def errors_purchase(errors)
      { purchase: nil, errors: errors }
    end
  end
end
