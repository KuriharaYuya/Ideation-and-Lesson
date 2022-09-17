module ApplicationHelper
  def set_title(page_title = "")
    #provideされているかどうか？
    base_title = "Ideation & Lessons"
    if page_title.empty?
      base_title
    end
  end
  include SessionsHelper
end
