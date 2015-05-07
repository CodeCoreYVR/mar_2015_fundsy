class PledgesController < ApplicationController
  before_action :authenticate_user!

  def create
    @campaign        = Campaign.find params[:campaign_id]
    @pledge          = Pledge.new pledge_params
    @pledge.user     = current_user
    @pledge.campaign = @campaign
    if @pledge.save
      redirect_to new_pledge_payment_path(@pledge), notice: "Pledge created"
    else
      flash[:alert] = "Pledge not created"
      render "campaigns/show"
    end
  end

  def destroy
    @campaign = Campaign.find params[:campaign_id]
    @pledge   = current_user.pledges.find params[:id]
    @pledge.destroy
    redirect_to @campaign, notice: "Pledge destroyed"
  end

  private

  def pledge_params
    params.require(:pledge).permit(:amount)
  end
end
