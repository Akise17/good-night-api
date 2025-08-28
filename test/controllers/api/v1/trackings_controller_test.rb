require 'test_helper'

class Api::V1::TrackingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:budi)
    @tracking = trackings(:with_clock_out_time)
  end

  def auth_headers
    { 'X-User-Id' => @user.id.to_s }
  end

  test 'should get index' do
    get api_v1_trackings_url, headers: auth_headers
    assert_response :success
    body = JSON.parse(response.body)
    assert_kind_of Array, body['data']
  end

  test 'should show tracking' do
    get api_v1_tracking_url(@tracking), headers: auth_headers
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @tracking.id, body['data']['id']
  end

  test 'should clock in' do
    assert_difference('Tracking.count') do
      post clock_in_api_v1_trackings_url, headers: auth_headers
    end
    assert_response :success
  end

  test 'should clock out' do
    new_tracking = @user.trackings.create!
    put clock_out_api_v1_tracking_url(new_tracking), headers: auth_headers
    assert_response :success
    new_tracking.reload
    refute_nil new_tracking.clock_out_time
  end

  test 'should destroy tracking' do
    tracking_without_clock_out = trackings(:without_clock_out_time)
    assert_difference('Tracking.count', -1) do
      delete api_v1_tracking_url(tracking_without_clock_out), headers: auth_headers
    end
    assert_response :success
  end
end
