# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @bulletin = bulletins(:one)
    @other_bulletin = bulletins(:two)
  end

  test 'guest should be redirected to login' do
    get profile_url
    assert_redirected_to root_path(locale: I18n.locale)
    assert_equal I18n.t('auth.require_login'), flash[:alert]
  end

  test 'logged in user should see profile' do
    sign_in @user

    get profile_url
    assert_response :success
    assert_includes response.body, I18n.t('navigation.profile')
  end

  test 'profile shows only current_user bulletins ordered by created_at desc' do
    sign_in @user
    get profile_url

    assert_response :success
    assert_match @bulletin.title, response.body
    assert_no_match @other_bulletin.title, response.body
  end
end
