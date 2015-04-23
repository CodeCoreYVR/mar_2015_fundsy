class CampaignsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

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

  def show
    @campaign = Campaign.find params[:id]
  end

  def edit
    @campaign = current_user.campaigns.find params[:id]
  end

  def update
    @campaign = current_user.campaigns.find params[:id]
    if @campaign.update campaign_params
      redirect_to @campaign, notice: "campaign updated"
    else
      flash[:alert] = "campaign wasn't updated"
      render :edit
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :goal, :ends_on)
  end
end
