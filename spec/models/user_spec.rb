# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    subject { create(:user) }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    subject { build(:user) }

    it { is_expected.to have_many(:sessions) }
  end
end
