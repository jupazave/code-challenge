# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'factory' do
    subject { create(:session) }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    subject { build(:session) }

    it { is_expected.to belong_to(:user) }
  end
end
