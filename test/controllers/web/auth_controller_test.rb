# frozen_string_literal: true

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'create' do
    auth_hash = {
      provider: 'github',
      uid: '54321',
      info: {
        email: Faker::Internet.email,
        name: Faker::Name.first_name
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_path('github')
    assert_response :redirect

    user = User.find_by(email: auth_hash[:info][:email].downcase)

    assert user
    assert signed_in?
  end

  test 'logout' do
    user = users(:non_admin)
    sign_in user

    delete logout_path
    assert_redirected_to root_path(locale: I18n.locale)

    follow_redirect!
    assert_equal I18n.t('auth.logout'), flash[:notice]
    assert_not signed_in?
  end
end
