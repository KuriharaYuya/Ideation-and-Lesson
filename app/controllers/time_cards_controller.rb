class TimeCardsController < ApplicationController
  include ApplicationHelper
  before_action :user_log_in, only: %w[edit update]
  def show
    @time_card = Lifelog.find(params[:id]).time_card
  rescue StandardError => e
    @time_card = TimeCard.find(params[:id]) if @time_card.nil?
  end

  def edit
    @time_card = Lifelog.find(params[:id]).time_card
  rescue StandardError => e
    @time_card = TimeCard.find(params[:id]) if @time_card.nil?
  end

  def update
    @time_card = TimeCard.find(params[:id])
    # judge & set be_on_time

    # judge & set gap
    if @time_card.update!(time_card_params)
      @time_card.update(be_on_time: @time_card.judge_be_on_time[:bool], gap_min: @time_card.judge_be_on_time[:gap])
      redirect_to time_card_path(@time_card)
    end
  end

  def time_card_params
    params.require(:time_card).permit(:arrived_time, :proof_img, :scheduled_time_tomorrow, :scheduled_time_today,
                                      :location_tomorrow, :location_today, :location_yesterday)
  end
end
