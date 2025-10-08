# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:non_admin)
    @bulletin = bulletins(:draft)
    @other_bulletin = bulletins(:under_moderation)
  end

  test 'profile check' do
    # guest should be redirected to login
    get profile_url
    assert_redirected_to root_path(locale: I18n.locale)
    assert_equal I18n.t('auth.require_login'), flash[:alert]

    # logged in user should see profile
    sign_in @user

    get profile_url
    assert_response :success
    assert_includes response.body, I18n.t('navigation.profile')

    # profile shows only current_user bulletins
    assert_match @bulletin.title, response.body
    assert_no_match @other_bulletin.title, response.body
  end
end
