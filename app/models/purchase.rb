class Purchase
  include Mongoid::Document
  include Mongoid::Timestamps

  field :customer_email, type: String
  field :customer_name, type: String
  field :quantity, type: Integer
  field :total_price, type: Float

  # Relationships
  belongs_to :event

  # Validations
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
end
