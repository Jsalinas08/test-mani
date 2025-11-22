require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      event = build(:event)
      expect(event).to be_valid
    end

    it 'is invalid without a name' do
      event = build(:event, name: nil)
      expect(event).not_to be_valid
    end

    it 'is invalid with negative available_tickets' do
      event = build(:event, available_tickets: -1)
      expect(event).not_to be_valid
    end
  end

  describe 'relationships' do
    it 'has many purchases' do
      event = create(:event)
      purchase = create(:purchase, event: event)
      expect(event.purchases).to include(purchase)
    end
  end

  # TODO: Candidates should add tests for:
  # - Index performance
  # - Query performance with filters
  # - Edge cases for ticket availability
end
