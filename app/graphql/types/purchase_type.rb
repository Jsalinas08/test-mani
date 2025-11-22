module Types
  class PurchaseType < Types::BaseObject
    field :id, ID, null: false
    field :customer_email, String, null: false
    field :customer_name, String, null: false
    field :quantity, Integer, null: false
    field :total_price, Float, null: false
    field :event, Types::EventType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
