# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # ============================================================
    # FEATURE 1: Event Listings with Filtering
    # ============================================================
    # TODO: Implement this query to return a paginated list of events
    # Requirements:
    # - Support filtering by category, city, and date range
    # - Implement pagination (you can choose cursor-based or offset-based)
    # - Ensure the query performs well with 1000+ events
    # - Consider: What indexes do you need in the Event model?
    field :events, [Types::EventType], null: false do
      argument :filters, Types::EventFilterInput, required: false
      argument :limit, Integer, required: false, default_value: 20
      argument :offset, Integer, required: false, default_value: 0
    end

    def events(filters: {}, limit: 20, offset: 0)
      # TODO: Implement filtering logic here
      # Consider performance implications with large datasets
      []
    end

    # ============================================================
    # FEATURE 3: Popular Events Ranking
    # ============================================================
    # TODO: Implement this query to return trending/popular events
    # Requirements:
    # - Return events ordered by purchase activity (most popular first)
    # - Consider recent purchases (e.g., last 7 days) for trending calculation
    # - Ensure query performs well at scale
    # - Consider: Aggregation pipelines? Pre-computed counters? Caching?
    field :popular_events, [Types::EventType], null: false do
      argument :limit, Integer, required: false, default_value: 10
      argument :days, Integer, required: false, default_value: 7, description: "Number of days to look back for popularity calculation"
    end

    def popular_events(limit: 10, days: 7)
      # TODO: Implement popularity ranking logic here
      # This is the most complex feature - think about performance!
      []
    end
  end
end
