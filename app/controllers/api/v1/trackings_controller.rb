# frozen_string_literal: true

class Api::V1::TrackingsController < Api::V1::BaseController
  before_action :set_resource, only: %i[clock_out show destroy]
  before_action :set_resources, only: %i[by_followers index]

  def clock_in
    @resource = current_user.trackings.new
    render_response if @resource.save!
  end

  def clock_out
    render_response if @resource.update!(clock_out_time: DateTime.current)
  end

  def by_followers
    @resources = @resources.by_date(params[:date_range]).followings_of(current_user).by_duration
    render_response
  end
end
