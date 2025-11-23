class EventDao  < BaseDao
  def filters(filters)
    events = all

    # Apply filters if provided
    events = events.by_category(filters[:category]) if filters[:category].present?
    events = events.by_city(filters[:city]) if filters[:city].present?

    if filters[:date_from].present? && filters[:date_to].present?
      events = events.range_date(filters[:date_from], filters[:date_to])
      return events
    end

    events = events.by_date_from(filters[:date_from]) if filters[:date_from].present?
    events = events.by_date_to(filters[:date_to]) if filters[:date_to].present?

    events
  end

  def all
    model.all
  end

  def event_resolver(event_id, quantity)
    model.where(id: event_id, :available_tickets.gte => quantity)&.find_one_and_update(
      {
        '$inc': { available_tickets: -quantity }  # Decrementa atómicamente
      },
      return_document: :after  # Devuelve el documento actualizado
    )
  end

  def find(event_id)
    model.find(event_id)
  end
end