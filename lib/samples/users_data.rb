# frozen_string_literal: true

module Samples
  class UsersData
    EMAIL = 'user@example.com'

    static_facade :up
    def up
      User.create_with(name: 'John Doe',
                       password: 'password')
          .find_or_create_by!(email: EMAIL)

      Rails.logger.info "User created with email: #{EMAIL}"
    end

    static_facade :down
    def down
      User.find_by(email: EMAIL)&.destroy!

      Rails.logger.info "User destroyed with email: #{EMAIL}"
    end
  end
end
