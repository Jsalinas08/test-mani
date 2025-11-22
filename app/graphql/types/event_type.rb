module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :date, GraphQL::Types::ISO8601DateTime, null: false
    field :venue, String, null: false
    field :city, String, null: false
    field :category, String, null: false
    field :total_tickets, Integer, null: false
    field :available_tickets, Integer, null: false
    field :price, Float, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Field for number of purchases (candidates may need this for popular events feature)
    field :purchases_count, Integer, null: false

    def purchases_count
      object.purchases.count
    end
  end
end
