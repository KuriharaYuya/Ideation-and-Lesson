module TimelinePagesHelper
  def to_HH_MM(minutes)
    hour = minutes / 60
    min = minutes - hour * 60
    if minutes >= 60
      "#{hour}時間#{min}分"
    else
      "#{min}分"
    end
  end

  def all_have_loaded?(add)
    @number_of_posted_microposts < @start_get + add
  end
end
