# frozen_string_literal: true

class Trackings::DetailSerializer < BaseSerializer
  attributes :id, :clock_in_time, :clock_out_time, :sleep_duration, :created_at

  attributes :user do |object|
    User::DetailSerializer.new(object.user).attributes
  end
end
