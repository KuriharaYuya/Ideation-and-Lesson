module LifelogsHelper
  include ApplicationHelper
  #   viewで見たいカラムをオプションで提示する
  # この関数を記入すると、オプションに対応したカラム名とvalueが帰ってくる
  # 引数に入れた変数typeによって、カラムを返すのかvalueを返すのか決める
  #  ダリーからとりま全部のカラム返すわ、リファクタリングの時にまたやれ
  def return_optional_value_of_lifelog(_type)
    view_columns = %i[post_type start_datetime]
    @result = []
    view_columns.each do |column|
      push_value = column.to_s if _type == 'column'
      @result.push(push_value)
      next unless _type == 'value'

      @microposts.each do |micropost|
        @result.push(micropost[column])
      end
    end
  end

  def set_lifelog_duration_time(type)
    std_date = @lifelog.log_date
    # default start_datetime is 3:31am
    start_datetime ||= 3.hours + 31.minutes
    @lifelog[:start_datetime] = std_date + start_datetime
    # default end_datetime is set next-day at 3:30am
    duration_datetime ||= 1.day - 1.minutes
    @lifelog[:end_datetime] = @lifelog[:start_datetime] + duration_datetime
    @lifelog.save!
    if type == 'start'
      start_datetime
    elsif type == 'duration'
      duration_datetime
    end
  end

  def is_duration_overlap?
    lifelog ||= @lifelog
    latest_lifelog = @user.lifelogs.order(log_date: :desc)[1]
    latest_lifelog[:end_datetime].after? lifelog[:start_datetime]
  end

  def assign_lifelog_to_micropost
    # if @micropost.lifelog.present?
    latest_lifelogs = @user.lifelogs.order(log_date: :desc)
    latest_lifelog = return_latest_lifelog
    if latest_lifelog.log_date.before? @micropost.exec_date
      # 紐づくべきlifelogがない場合
      @lifelog = Lifelog.new(user_id: current_user.id, log_date: @micropost.exec_date)
      set_lifelog_duration_time('calc')
      @lifelog.save
      @micropost.update(lifelog_id: @lifelog.id)
    end
    # micropostが紐づくべきlifelogがある場合
    if (latest_lifelog.log_date.after? @micropost.exec_date) || latest_lifelog.log_date == @micropost.exec_date
      @i = 0
      latest_lifelogs.each do |lifelog|
        break if @i == 31

        @i += 1
        next unless lifelog.log_date == @micropost.exec_date

        @bind_lifelog = lifelog
        @micropost.update(lifelog_id: @bind_lifelog.id,
                          exec_date: @bind_lifelog.log_date)
        break
      end
    end
    # ↓ lifelog would have bind & save
  end

  def set_current_datetime_to_logdate
    current_date = Time.now
    @lifelog.update(log_date: current_date) if @lifelog.present?
  end

  def return_latest_lifelog
    @user.lifelogs.order(log_date: :desc)[0]
  end
end
