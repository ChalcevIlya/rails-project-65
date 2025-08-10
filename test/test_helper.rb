# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    setup do
      attach_fixture_images
    end

    private

    def attach_fixture_images
      Bulletin.find_each do |bulletin|
        next if bulletin.image.attached?

        path = Rails.root.join('test/fixtures/files/music.jpg')
        bulletin.image.attach(io: File.open(path), filename: 'music.jpg', content_type: 'image/jpg')
      end
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user, _options = {})
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        name: user.name
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user = User.find_by(id: session[:user_id]) unless defined?(@current_user)
    @current_user
  end
end
