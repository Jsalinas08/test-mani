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

  # Indexes for query performance
  index({ category: 1, city: 1, date: 1 })
  index({ city: 1, date: 1 })
  index({ category: 1, date: 1 })
  index({ date: 1 })
  index({ category: 1 })
  index({ _id: 1 })

  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true
  validates :city, presence: true
  validates :category, presence: true
  validates :total_tickets, presence: true, numericality: { greater_than: 0 }
  validates :available_tickets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :by_category, -> (category) { where(category: category) }
  scope :by_city, -> (city) { where(city: city) }
  scope :by_date_from, -> (date) { where(:date.gte => date.beginning_of_day) }
  scope :by_date_to, -> (date) { where(:date.lte => date.end_of_day) }
  scope :range_date, -> (date_from, date_to) { where(:date.gte => date_from.beginning_of_day, :date.lte => date_to.end_of_day) }
end
