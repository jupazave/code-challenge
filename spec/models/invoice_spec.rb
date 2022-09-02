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

  describe 'validations' do
    subject { build(:invoice) }

    it { is_expected.to validate_presence_of(:invoice_uuid) }
    it { is_expected.to validate_uniqueness_of(:invoice_uuid).case_insensitive }
  end

  describe 'monetize' do
    subject { build(:invoice) }

    it { is_expected.to monetize(:amount_cents) }
  end

  describe 'methods' do
    describe '#qrcode' do
      subject { build(:invoice) }

      it 'returns a RQRCode::QRCode' do
        expect(subject.qrcode).to be_a(RQRCode::QRCode)
      end
    end
  end
end
