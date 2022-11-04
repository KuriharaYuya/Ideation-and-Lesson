class TimelinePagesController < ApplicationController
  include TimelinePagesHelper
  def home
    if params[:post_length].nil?
      reload_feed(0)
    else
      reload_feed(params[:post_length].to_i)
    end
  end

  private

  def reload_feed(start_get)
    @microposts = []
    start_get ||= 0
    @start_get = start_get
    @number_of_load_microposts = 21
    @number_of_posted_microposts = Micropost.where(posted?: true).all.length
    Micropost.all.order(posted_at: :desc)[0..(start_get + @number_of_load_microposts)].each do |micropost|
      @i ||= 0
      break if @i == @start_get + (@number_of_load_microposts + 1) || micropost.nil?

      if micropost.posted_at.present?
        @microposts.push(micropost)
        @i += 1
      end
    end
  end
end
