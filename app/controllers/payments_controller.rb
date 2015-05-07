class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pledge
  before_action :authorize_pledge

  def new
  end

  def create
    service = Payments::CreatePayment.new(user: current_user,
                                          stripe_token: params[:stripe_token],
                                          pledge: @pledge)
    if service.call
      redirect_to @pledge.campaign, notice: "Thank you for Pledging"
    else
      render :new
    end
  end

  private

  def find_pledge
    @pledge = Pledge.find params[:pledge_id]
  end

  def authorize_pledge
    redirect_to @pledge.campaign, notice: "Already paid" if @pledge.paid?
  end

end
