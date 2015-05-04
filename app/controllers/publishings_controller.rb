class PublishingsController < ApplicationController
  before_action :authenticate_user!

  def create
    campaign = Campaign.find params[:campaign_id]
    campaign.publish
    if campaign.save
      redirect_to campaign, notice: "Campaign Published"
    else
      redirect_to campaign, alert: "Campaign wasn't published"
    end
  end
end
