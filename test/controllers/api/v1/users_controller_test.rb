# frozen_string_literal: true

require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:budi)
  end

  test 'should get index' do
    get api_v1_users_url, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert body['data'].is_a?(Array)
    assert_equal @user.name, body['data'].first['name']
  end

  test 'should show user' do
    get api_v1_user_url(@user), as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal @user.name, body['data']['name']
  end

  test 'should create user' do
    assert_difference('User.count', 1) do
      post api_v1_users_url, params: { user: { name: 'New User' } }, as: :json
    end
    assert_response :success
  end

  test 'should update user' do
    patch api_v1_user_url(@user), params: { user: { name: 'Updated Name' } }, as: :json
    assert_response :success
    @user.reload
    assert_equal 'Updated Name', @user.name
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), as: :json
    end

    assert_response :no_content
  end
end
