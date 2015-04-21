class CampaignsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new campaign_params
    @campaign.user = current_user
    if @campaign.save
      flash[:notice] = "Campaign Created"
      redirect_to campaign_path(@campaign)
    else
      flash[:alert] = "Campaign not created!"
      render :new
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :goal, :ends_on)
  end
end
