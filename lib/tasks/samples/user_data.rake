# frozen_string_literal: true

require_relative '../../samples/users_data'

namespace :samples do
  namespace :users_data do
    desc 'Generate users data'
    task up: [:environment] do
      Samples::UsersData.up
    end

    task down: [:environment] do
      Samples::UsersData.down
    end
  end
end
