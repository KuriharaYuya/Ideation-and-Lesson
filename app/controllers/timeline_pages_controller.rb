class TimelinePagesController < ApplicationController
  include ApplicationHelper
  include TimelinePagesHelper
  def home
    if params[:post_length].nil?
      reload_feed(0)
    else
      reload_feed(params[:post_length].to_i)
    end
  end

  def explore
    @user = User.new
    # if (params[:commit] == '検索') && params[:name_search] != ''
    # 検索欄に値が存在した上で検索ボタンが押された場合
    # 選択されたソートオプションを実行して返す
    conditions = { following_asc?: following_asc?, registered_at_asc?: registered_at_asc?, name_asc?: name_asc? }
    @searched_user = if params[:name_search] == '' || params[:name_search].nil?
                       User.all
                     elsif params[:match_option] == 'exact_match'
                       User.where(name: params[:name_search])
                     elsif params[:match_option] == 'partial_match'
                       User.where('name LIKE ?', "%#{params[:name_search]}%")
                     elsif params[:match_option] == 'forward_match'
                       User.where('name LIKE ?', "#{params[:name_search]}%")
                     elsif params[:match_option] == 'backward_match'
                       User.where('name LIKE ?', "%#{params[:name_search]}")
                     end
    # end
    if conditions[:registered_at_asc?]
      @searched_user.order!(created_at: :asc)
    else
      @searched_user.order!(created_at: :desc)
    end

    if conditions[:name_asc?]
      @searched_user.order!(name: :asc)
    else
      @searched_user.order!(name: :desc)
    end

    if params[:following_asc] == '1'
      @searched_user.each do |user|
        @following_status ||= []
        if current_user.following?(user)
          @following_status.push([user, true])
        else
          @following_status.push([user, false])
        end
      end
      if @following_status
        @following_status.sort_by! { |x| x[0][1] }
        @searched_user = []
        @following_status.each do |status|
          user = status[0]
          @searched_user.push(user)
        end
      end
    end
    if @searched_user.length > 25
      @searched_user = if @searched_user.is_a?(Array)
                         Kaminari.paginate_array(@searched_user).page(params[:page]).per(10)
                       else
                         @searched_user.page(params[:page])
                       end
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
