module Types
  class EventFilterInput < Types::BaseInputObject
    description "Input type for filtering events"

    argument :category, String, required: false, description: "Filter by category"
    argument :city, String, required: false, description: "Filter by city"
    argument :date_from, GraphQL::Types::ISO8601DateTime, required: false, description: "Filter events from this date"
    argument :date_to, GraphQL::Types::ISO8601DateTime, required: false, description: "Filter events until this date"
  end
end
