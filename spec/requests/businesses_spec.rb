# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/businesses', type: :request do
  let(:valid_attributes) do
    {
      tax_name: FFaker::NameMX.full_name,
      tax_id: FFaker::IdentificationMX.rfc
    }
  end

  let(:invalid_attributes) do
    {
      taxname: FFaker::NameMX.full_name
    }
  end

  let!(:session) { create(:session) }

  let!(:headers) do
    {
      Authorization: "Bearer #{session.session_id}"
    }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /index' do
    let!(:business) { create(:business) }

    it 'renders a successful response' do
      get businesses_url, headers:, as: :json
      expect(response).to be_successful
    end

    context 'when the request is not authorized' do
      let!(:headers) do
        {
          Authorization: 'Bearer unknown'
        }
      end

      it 'renders a 401 response' do
        get businesses_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /show' do
    subject { get business_url(business), headers:, as: :json }

    let!(:business) { create(:business) }

    it 'renders a successful response' do
      subject
      expect(response).to be_successful
    end

    it 'renders the invoice' do
      subject
      expect(json).to \
        match(
          a_hash_including(
            'id' => business.id,
            'tax_name' => business.tax_name,
            'tax_id' => business.tax_id
          )
        )
    end

    context 'when the invoice request does not exists' do
      it 'renders a 404 response' do
        get business_url(999_999), headers:, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      subject do
        post(businesses_url, params: { business: valid_attributes },
                             headers:,
                             as: :json)
      end

      it 'creates a new Business' do
        expect { subject }.to change(Business, :count).by(1)
      end

      it 'renders a JSON response with the new business' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      subject do
        post(businesses_url, params: { business: invalid_attributes },
                             headers:,
                             as: :json)
      end

      it 'does not create a new Business' do
        expect { subject }.not_to change(Business, :count)
      end

      it 'renders a JSON response with errors for the new business' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      subject do
        patch(business_url(business), params: { business: new_attributes },
                                      headers:,
                                      as: :json)
      end

      let(:new_attributes) do
        {
          tax_name: FFaker::NameMX.full_name,
          tax_id: FFaker::IdentificationMX.rfc
        }
      end

      let!(:business) { create(:business) }

      it 'updates the requested business' do
        subject
        expect { business.reload }.to change(business, :tax_name)
        expect { business.reload }.not_to change(business, :tax_id)
        expect(business.reload.tax_name).to eq(new_attributes[:tax_name])
      end

      it 'renders a JSON response with the business' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end
    end
  end
end
