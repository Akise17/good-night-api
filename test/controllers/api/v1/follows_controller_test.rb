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

  test 'by_followers returns only followings trackings' do
    @follower = @other_user
    @non_follower = users(:andy)

    @follower.follow(@user)

    @follower_tracking = Tracking.create!(user: @follower, clock_in_time: 2.hours.ago, clock_out_time: 1.hour.ago)
    @non_follower_tracking = Tracking.create!(user: @non_follower, clock_in_time: 3.hours.ago, clock_out_time: 2.hours.ago)

    @user.follow(@follower)

    get by_followers_api_v1_trackings_url(date_range: Date.today.to_s), headers: auth_headers, as: :json

    assert_response :success

    body = JSON.parse(response.body)
    user_ids = body['data'].map { |t| t['user']['id'] }

    assert_includes user_ids, @follower.id
    assert_not_includes user_ids, @non_follower.id
  end
end
