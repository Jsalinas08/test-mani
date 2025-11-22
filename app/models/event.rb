class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :date, type: DateTime
  field :venue, type: String
  field :city, type: String
  field :category, type: String
  field :total_tickets, type: Integer
  field :available_tickets, type: Integer
  field :price, type: Float

  # Relationships
  has_many :purchases

  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true
  validates :city, presence: true
  validates :category, presence: true
  validates :total_tickets, presence: true, numericality: { greater_than: 0 }
  validates :available_tickets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
