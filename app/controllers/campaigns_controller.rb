class CampaignsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @campaigns = Campaign.all
    respond_to do |format|
      format.html
      format.json { render json: @campaigns }
    end
  end

  def new
    @campaign = Campaign.new
    3.times { @campaign.reward_levels.build }
  end

  def create
    @campaign = Campaign.new campaign_params
    @campaign.user = current_user
    if @campaign.save
      flash[:notice] = "Campaign Created!"
      redirect_to campaign_path(@campaign)
    else
      flash[:alert] = "Campaign not created!"
      render :new
    end
  end

  def show
    @campaign = Campaign.find params[:id]
    respond_to do |format|
      format.html
      format.json {render json: {campaign:      @campaign, 
                                 reward_levels: @campaign.reward_levels} }
    end
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

  def destroy
    @campaign = current_user.campaigns.find params[:id]
    @campaign.destroy
    redirect_to campaigns_path, notice: "Campaign deleted"
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :goal, :ends_on,
                                      {reward_levels_attributes: 
                                          reward_level_attributes_params})
  end

  def reward_level_attributes_params
    [:amount, :description, :id, :_destroy]
  end
end
