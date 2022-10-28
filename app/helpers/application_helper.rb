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
    @msg = msg if msg.present?
    # list of type  => info, complete, warn, danger
    render "layouts/flash/#{type}"
  end
  include SessionsHelper
end
