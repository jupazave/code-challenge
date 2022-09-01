# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceUploadProcessorJob, type: :job do
  describe '#perform' do
    subject { described_class.perform_now(invoice_upload) }

    let!(:invoice_upload) { create(:invoice_upload, :with_valid_invoice) }

    it 'creates a new invoice' do
      expect { subject }.to change(Invoice, :count).by(1)
    end

    it 'creates emitter and receiver businesses' do
      expect { subject }.to change(Business, :count).by(2)
    end

    it 'destroys the uploaded files' do
      expect { subject }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'destroys a InvoiceUpload' do
      expect { subject }.to change(InvoiceUpload, :count).by(-1)
    end

    it 'does not call the InvoiceUploadInvalidNotifier' do
      allow(InvoiceUploadInvalidNotifier).to receive(:call).and_call_original
      subject
      expect(InvoiceUploadInvalidNotifier).not_to have_received(:call)
    end

    context 'with an invalid xml' do
      let!(:invoice_upload) do
        create(:invoice_upload, :with_invalid_invoice)
      end

      let!(:user) { invoice_upload.user }

      it 'does not create a new invoice' do
        expect { subject }.not_to change(Invoice, :count)
      end

      it 'call the InvoiceUploadInvalidNotifier with arguments' do
        allow(InvoiceUploadInvalidNotifier).to receive(:call).and_call_original
        subject
        expect(InvoiceUploadInvalidNotifier).to \
          have_received(:call).with(user, 1)
      end
    end

    context 'with a valid and invalid xml' do
      let!(:invoice_upload) do
        create(:invoice_upload, :with_valid_and_invalid_invoice)
      end

      let!(:user) { invoice_upload.user }

      it 'creates a new invoice' do
        expect { subject }.to change(Invoice, :count).by(1)
      end

      it 'call the InvoiceUploadInvalidNotifier with arguments' do
        allow(InvoiceUploadInvalidNotifier).to receive(:call).and_call_original
        subject
        expect(InvoiceUploadInvalidNotifier).to \
          have_received(:call).with(user, 1)
      end

      it 'destroys the uploaded files' do
        expect { subject }.to change(ActiveStorage::Attachment, :count).by(-2)
      end

      it 'destroys a InvoiceUpload' do
        expect { subject }.to change(InvoiceUpload, :count).by(-1)
      end
    end

    context 'with an existing invoice' do
      let!(:business_emitter) do
        create(:business, tax_name: 'Brenda Hinojosa Quiñones',
                          tax_id: 'QTX860320FCL')
      end

      let!(:business_receiver) do
        create(:business, tax_name: 'Tamara Georgina Mercado Espinoza',
                          tax_id: 'HAV951105297')
      end
      let!(:invoice) do
        create(:invoice, invoice_uuid: 'ad110156-a7df-4a2f-b657-85959918037c',
                         business_emitter:,
                         business_receiver:)
      end

      it 'does not create an invoice' do
        expect { subject }.not_to change(Invoice, :count)
      end

      it 'does not call the InvoiceUploadInvalidNotifier' do
        allow(InvoiceUploadInvalidNotifier).to receive(:call).and_call_original
        subject
        expect(InvoiceUploadInvalidNotifier).not_to have_received(:call)
      end
    end
  end
end
