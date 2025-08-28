# frozen_string_literal: true

require 'test_helper'

class Api::V1::FollowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:budi)
    @other_user = users(:ricky)
  end

  def auth_headers
    { 'X-User-Id' => @user.id.to_s }
  end
  test 'should follow another user' do
    assert_difference('@user.followings.count', +1) do
      post follow_api_v1_follow_url(@other_user.id), headers: auth_headers
    end

    assert_response :no_content
    assert_includes @user.followings.reload, @other_user
  end

  test 'should unfollow a user' do
    @user.follow(@other_user)
    assert_includes @user.followings, @other_user

    assert_difference('@user.followings.count', -1) do
      delete unfollow_api_v1_follow_url(@other_user.id), headers: auth_headers
    end

    assert_response :no_content
    assert_not_includes @user.followings.reload, @other_user
  end
end
