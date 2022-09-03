# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceUploadInvalidNotifier do
  subject { described_class.call(user, count) }

  let!(:user) { create(:user) }
  let(:count) { 10 }

  it 'logs the error' do
    allow(Rails.logger).to receive(:error).and_call_original
    subject
    expect(Rails.logger).to \
      have_received(:call).with(
        "User #{user.email} uploaded #{count} invalid invoices"
      )
  end
end
