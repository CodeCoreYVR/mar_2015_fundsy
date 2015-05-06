class Api::V1::CampaignsController < Api::V1::BaseController

  def index
    @campaigns = Campaign.most_recent(30)
    # render json: @campaigns
  end

  def show
    # include
    # title description goal (in currency format) and ends_on
    # reward_levels (amount and description)
    @campaign = Campaign.find(params[:id]).decorate
  end

  def create
    render json: {hello: "There"}
  end
end
