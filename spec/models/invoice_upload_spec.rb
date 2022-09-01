# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceUpload, type: :model do
  describe 'factory' do
    subject { create(:invoice_upload) }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    subject { build(:invoice_upload) }

    it { is_expected.to belong_to(:user) }
  end

  describe 'methods' do
    describe '#invoices' do
      subject { create(:invoice_upload).invoices }

      it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
    end
  end
end
