# frozen_string_literal: true

if Rails.env.development?
  3.times do |i|
    User.create!(name: "User #{i}")
  end

  User.all.find_each do |user|
    1000.times do |i|
      clock_in_time = Faker::Time.between(from: 10.days.ago, to: 1.day.ago)
      clock_out_time = clock_in_time + rand(1..8).hours
      user.trackings.create!(clock_in_time: clock_in_time, clock_out_time: clock_out_time, sleep_duration: (clock_out_time - clock_in_time).to_i)
    end
  end
end
