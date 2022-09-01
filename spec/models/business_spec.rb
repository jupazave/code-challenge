# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business, type: :model do
  describe 'factory' do
    subject { create(:business) }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    subject { build(:business) }

    it { is_expected.to have_many(:emitter_invoices) }
    it { is_expected.to have_many(:receiver_invoices) }
  end

  describe 'validations' do
    subject { build(:business) }

    it { is_expected.to validate_presence_of(:tax_name) }
    it { is_expected.to validate_presence_of(:tax_id) }
    it { is_expected.to validate_uniqueness_of(:tax_id) }
  end
end
