# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawInvoiceBuilder do
  describe '::call' do
    subject { described_class.call(raw_xml) }

    let(:raw_xml) do
      File.read('spec/fixtures/test-invoice.xml')
    end

    it 'returns a Invoice' do
      expect(subject.invoice).to be_a(Invoice)
    end

    it 'returns a successful result' do
      expect(subject).to be_successful
    end

    it 'creates a new invoice' do
      expect { subject }.to change(Invoice, :count).by(1)
    end

    it 'creates emitter and receiver businesses' do
      expect { subject }.to change(Business, :count).by(2)
    end

    context 'with an invalid xml' do
      let(:raw_xml) do
        File.read('spec/fixtures/test-invoice-invalid.xml')
      end

      it 'returns a unsuccessful result' do
        expect(subject).not_to be_successful
      end

      it 'returns an error' do
        expect(subject.errors).to include(:missing_invoice_uuid)
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

      it 'returns a successful result' do
        expect(subject).to be_successful
      end

      it 'updates the invoice' do
        expect { subject }.not_to change(Invoice, :count)
      end

      it 'does not create business' do
        expect { subject }.not_to change(Business, :count)
      end
    end

    context 'when the receiver business exists' do
      let!(:business_receiver) do
        create(:business, tax_name: 'Tamara Georgina Mercado Espinoza',
                          tax_id: 'HAV951105297')
      end

      it 'returns a successful result' do
        expect(subject).to be_successful
      end

      it 'creates the emitter business' do
        expect { subject }.to change(Business, :count).by(1)
      end
    end
  end
end
