# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'factory' do
    subject { create(:invoice) }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    subject { build(:invoice) }

    it { is_expected.to belong_to(:business_emitter) }
    it { is_expected.to belong_to(:business_receiver) }
  end
end
