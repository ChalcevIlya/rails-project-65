# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @bulletin = bulletins(:one)
    sign_in(@user)
  end

  test 'should get index' do
    get bulletins_path
    assert_response :success
  end

  test 'should show bulletin' do
    get bulletin_path(@bulletin)
    assert_response :success
  end

  test 'should get new bulletin form' do
    get new_bulletin_path
    assert_response :success
  end

  test 'should create bulletin' do
    image = fixture_file_upload('music.jpg', 'image/jpeg')

    assert_difference('Bulletin.count') do
      post bulletins_path, params: {
        bulletin: {
          title: 'Test',
          description: 'Description',
          category_id: categories(:one).id,
          image: image
        }
      }
    end

    bulletin = Bulletin.last
    assert_redirected_to bulletin_path(bulletin, locale: I18n.locale)
    assert_equal @user.id, bulletin.user_id
  end

  test 'should get edit if author' do
    get edit_bulletin_path(@bulletin)
    assert_response :success
  end

  test 'should update bulletin if author' do
    patch bulletin_path(@bulletin), params: {
      bulletin: { title: 'Updated Title' }
    }
    assert_redirected_to bulletin_path(@bulletin, locale: I18n.locale)
    @bulletin.reload
    assert_equal 'Updated Title', @bulletin.title
  end

  test 'should archive bulletin if allowed' do
    @bulletin.update!(state: :published)
    patch archive_bulletin_path(@bulletin)
    assert_redirected_to profile_path(locale: I18n.locale)
    @bulletin.reload
    assert_equal 'archived', @bulletin.state
  end

  test 'should send bulletin to moderation if allowed' do
    @bulletin.update!(state: :draft)
    patch send_to_moderation_bulletin_path(@bulletin)
    assert_redirected_to profile_path(locale: I18n.locale)
    @bulletin.reload
    assert_equal 'under_moderation', @bulletin.state
  end

  test 'should not send bulletin to moderation if invalid state' do
    @bulletin.update!(state: :published)
    patch send_to_moderation_bulletin_path(@bulletin)
    assert_redirected_to profile_path(locale: I18n.locale)
    @bulletin.reload
    assert_equal 'published', @bulletin.state
  end

  test 'should not allow edit of someone else’s bulletin' do
    other_user_bulletin = bulletins(:two)
    get edit_bulletin_path(other_user_bulletin)
    assert_redirected_to root_path(locale: I18n.locale)
    assert_equal I18n.t('auth.access_denied'), flash[:alert]
  end

  test 'should not allow archive of someone else’s bulletin' do
    other_user_bulletin = bulletins(:two)
    patch archive_bulletin_path(other_user_bulletin)
    assert_redirected_to root_path(locale: I18n.locale)
    assert_equal I18n.t('auth.access_denied'), flash[:alert]
  end
end
