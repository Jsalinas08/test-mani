class PurchaseDao < BaseDao
  def create_purchase(event_obj:, customer_email:, customer_name:, quantity:)
    debugger
    model.create!(
      event: event_obj,
      customer_email: customer_email,
      customer_name: customer_name,
      quantity: quantity,
      total_price: event_obj.price * quantity
    )
  end
end