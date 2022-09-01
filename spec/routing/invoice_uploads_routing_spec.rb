# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceUploadsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/invoice_uploads').to route_to('invoice_uploads#create')
    end
  end
end
