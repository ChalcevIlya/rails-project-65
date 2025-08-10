# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:two)
    @bulletin_under_moderation = bulletins(:two)
    sign_in(@admin)
  end

  test 'should get index' do
    get admin_bulletins_path(locale: I18n.locale)
    assert_response :success
  end

  test 'should get dashboard' do
    get admin_root_path(locale: I18n.locale)
    assert_response :success
  end

  test 'should publish bulletin' do
    patch publish_admin_bulletin_url(@bulletin_under_moderation)
    assert_redirected_to admin_root_path(locale: I18n.locale)
    @bulletin_under_moderation.reload
    assert_equal 'published', @bulletin_under_moderation.state
  end

  test 'should reject bulletin' do
    patch reject_admin_bulletin_url(@bulletin_under_moderation)
    assert_redirected_to admin_root_path(locale: I18n.locale)
    @bulletin_under_moderation.reload
    assert_equal 'rejected', @bulletin_under_moderation.state
  end

  test 'should archive bulletin' do
    @bulletin_under_moderation.update!(state: :published)
    patch archive_admin_bulletin_url(@bulletin_under_moderation)
    assert_redirected_to admin_root_path(locale: I18n.locale)
    @bulletin_under_moderation.reload
    assert_equal 'archived', @bulletin_under_moderation.state
  end

  test 'should not publish if invalid state' do
    @bulletin_under_moderation.update!(state: :draft)
    patch publish_admin_bulletin_url(@bulletin_under_moderation)
    assert_redirected_to admin_root_path(locale: I18n.locale)
    @bulletin_under_moderation.reload
    assert_equal 'draft', @bulletin_under_moderation.state
  end
end
