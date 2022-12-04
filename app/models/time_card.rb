class TimeCard < ApplicationRecord
  belongs_to :lifelog
  mount_uploader :proof_img, ImageUploader

  # def initialize
  #   import_scheduled_time
  # end

  def set_yesterday_lifelog
    @yesterday_lifelog_date = lifelog.log_date.prev_day(1)
    @yesterday_lifelog = Lifelog.find_by(log_date: @yesterday_lifelog_date)
  end

  def is_scheduled_time_set?
    set_yesterday_lifelog
    @yesterday_lifelog.time_card.scheduled_time_tomorrow.nil?
  end

  def import_scheduled_time
    # 使うときは前日のカードに "scheduled_time_tomorrow"がセットされているか確認してね
    set_yesterday_lifelog
    import_from = @yesterday_lifelog.time_card.scheduled_time_tomorrow
    update(scheduled_time_today: import_from)
    scheduled_time_today
  end

  def import_location
    # 使うときは前日のカードに "scheduled_time_tomorrow"がセットされているか確認してね
    set_yesterday_lifelog
    import_from = @yesterday_lifelog.time_card.location_tomorrow
    update(location_yesterday: import_from)
    location_yesterday
  end

  def judge_be_on_time
    gap = (arrived_time - scheduled_time_today) * 10 / 600
    result = { bool: gap <= 15, gap: }
  end
end
