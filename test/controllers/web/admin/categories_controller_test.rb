# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:two)
    @non_admin = users(:one)
    @category = categories(:one)
  end

  test 'admin should get index' do
    sign_in(@admin)
    get admin_categories_path
    assert_response :success
  end

  test 'non-admin should not get index' do
    sign_in(@non_admin)
    get admin_categories_path
    assert_redirected_to root_path
    assert_equal I18n.t('auth.access_denied'), flash[:alert]
  end

  test 'admin should get new' do
    sign_in(@admin)
    get new_admin_category_path
    assert_response :success
  end

  test 'admin should create category' do
    sign_in(@admin)
    assert_difference('Category.count') do
      post admin_categories_path, params: { category: { name: 'Test Category' } }
    end
    assert_redirected_to admin_categories_path
  end

  test 'admin should not create category with invalid data' do
    sign_in(@admin)
    assert_no_difference('Category.count') do
      post admin_categories_path, params: { category: { name: '' } }
    end
    assert_response :unprocessable_entity
  end

  test 'admin should get edit' do
    sign_in(@admin)
    get edit_admin_category_path(@category)
    assert_response :success
  end

  test 'admin should update category' do
    sign_in(@admin)
    patch admin_category_path(@category), params: { category: { name: 'UpdatedName' } }
    assert_redirected_to admin_categories_path
    @category.reload
    assert_equal 'UpdatedName', @category.name
  end

  test 'admin should not update category with invalid data' do
    sign_in(@admin)
    patch admin_category_path(@category), params: { category: { name: '' } }
    assert_response :unprocessable_entity
    @category.reload
    assert_not_equal '', @category.name
  end

  test 'admin should destroy category' do
    sign_in(@admin)
    assert_difference('Category.count', -1) do
      delete admin_category_path(@category)
    end
    assert_redirected_to admin_categories_path
  end

  test 'non-admin should not access category routes' do
    sign_in(@non_admin)

    get admin_categories_path
    assert_redirected_to root_path

    get new_admin_category_path
    assert_redirected_to root_path

    post admin_categories_path, params: { category: { name: 'Nope' } }
    assert_redirected_to root_path

    get edit_admin_category_path(@category)
    assert_redirected_to root_path

    patch admin_category_path(@category), params: { category: { name: 'Nope' } }
    assert_redirected_to root_path

    delete admin_category_path(@category)
    assert_redirected_to root_path
  end
end
