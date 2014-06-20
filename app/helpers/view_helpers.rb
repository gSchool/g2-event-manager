module ViewHelpers

  def time_to_12_hour(time)
    sliced_time = time.slice(0..1)
    if sliced_time.length == 2 && sliced_time[0].to_i == 0
      another_time = sliced_time.slice(1)
    else
      another_time = sliced_time
    end

    new_time = 24 - another_time.to_i
    if new_time > 12
      another_time + "am"
    else
      (another_time.to_i - 12).to_s + "pm"
    end
  end
end