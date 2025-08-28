# frozen_string_literal: true

class Api::V1::TrackingsController < Api::V1::BaseController
  before_action :set_resource, only: %i[clock_out show destroy]

  def clock_in
    @resource = current_user.trackings.new
    render_response if @resource.save!
  end

  def clock_out
    render_response if @resource.update!(clock_out_time: DateTime.current)
  end
end
