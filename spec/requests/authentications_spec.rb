# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /auth/login' do
    subject { post '/auth/login', params:, as: :json }

    let(:password) { 'mypassword' }
    let!(:user) do
      create(:user, password_digest: BCrypt::Password.create(password))
    end
    let(:params) { { email: user.email, password: } }

    let(:json) { JSON.parse(response.body) }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns a session_id' do
      subject
      expect(json['session_id']).to be_present
    end

    it 'creates a new session' do
      expect { subject }.to change(Session, :count).by(1)
    end

    it 'returns the session_id' do
      subject
      expect(json['session_id']).to eq(Session.last.session_id)
    end

    context 'when the user does not exist' do
      let(:params) { { email: 'unknown', password: } }

      it 'returns http unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new session' do
        expect { subject }.not_to change(Session, :count)
      end

      it 'returns an error message' do
        subject
        expect(json['error']).to eq('Invalid credentials')
      end
    end

    context 'when the password is incorrect' do
      let(:params) { { email: user.email, password: 'unknown' } }

      it 'returns http unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new session' do
        expect { subject }.not_to change(Session, :count)
      end

      it 'returns an error message' do
        subject
        expect(json['error']).to eq('Invalid credentials')
      end
    end
  end
end
