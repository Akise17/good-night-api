# frozen_string_literal: true

class Trackings::IndexSerializer < BaseSerializer
  attributes :id, :clock_in_time, :clock_out_time, :sleep_duration, :created_at
end
