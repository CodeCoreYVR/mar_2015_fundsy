class Campaigns::CreateCampaign

  include Virtus.model

  # input
  attribute :params, Hash
  attribute :user, User

  # output
  attribute :campaign, Campaign

  def call
    @campaign = Campaign.new params
    @campaign.user = user
    @campaign.save
  end

end
