module ApplicationHelper
  def set_title(page_title = '')
    # provideされているかどうか？
    base_title = 'Ideation & Lessons'
    base_title if page_title.empty?
  end

  def get_all_column_names(class_name)
    class_name.column_names
  end

  def alert(type, msg)
    unless flash.empty?
      # list of type  => info, complete, warn, danger
      @msg = msg if msg.present?
      render "layouts/flash/#{type}"
    end
  end

  def return_notification
    if logged_in?
      @user = current_user
      @notification = Notification.where(visited_id: @user.id)
    end
  end
  include SessionsHelper
end
