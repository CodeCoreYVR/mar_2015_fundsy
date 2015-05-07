class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pledge

  def new
  end

  def create
    customer = Stripe::Customer.create(
                :description => "Customer for #{current_user.email}",
                :source => params[:stripe_token]
              )
    current_user.stripe_customer_token = customer.id
    current_user.stripe_last4 = customer.cards.data[0].last4
    current_user.stripe_card_type = customer.cards.data[0].brand

    current_user.save

    charge = Stripe::Charge.create(
      :amount => @pledge.amount * 100,
      :currency => "cad",
      :customer => current_user.stripe_customer_token, 
      :description => "Pledge for #{@pledge.campaign.title}"
    )

    @pledge.stripe_txn_id = charge.id
    @pledge.pay
    @pledge.save

    redirect_to @pledge.campaign, notice: "Thank you for Pledging"
  end

  private

  def find_pledge
    @pledge = Pledge.find params[:pledge_id]
  end

end
