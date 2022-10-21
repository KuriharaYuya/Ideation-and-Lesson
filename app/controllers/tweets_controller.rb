class TweetsController < ApplicationController
  before_action :tweet_basic_auth, only: %w[edit]
  def edit
    @user_setting = current_user.user_setting
  end

  def new
    user = current_user
    lifelogs = user.lifelogs.order(tweeted?: :asc)
    @untweeted_lifelog = []
    lifelogs.each do |lifelog|
      break if lifelog.tweeted? == true

      @untweeted_lifelog.push(lifelog)
    end
    @untweeted_lifelog.sort_by! { |x| x['log_date'] }
    @untweeted_lifelog.reverse!
  end

  def create
    @lifelog_id = params[:lifelog_id]
    user = current_user
    user.user_setting.update(post_lifelog_id: @lifelog_id)
    run_rake_task_tweet
    redirect_to new_tweet_path

  end

  private

  def tweet_basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['TWITTER_BASIC_AUTH_USER'] && password == ENV['TWITTER_BASIC_AUTH_PASSWORD']
    end
  end

  def run_rake_task_tweet
    require 'rake'
    Rails.application.load_tasks
    Rake::Task['twitter_mov_test'].execute
    Rake::Task['twitter_mov_test'].clear
  end
end
