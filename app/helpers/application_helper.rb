module ApplicationHelper
  def set_title(page_title = '')
    # provideされているかどうか？
    base_title = 'Ideation & Lessons'
    base_title if page_title.empty?
  end
  include SessionsHelper
end
