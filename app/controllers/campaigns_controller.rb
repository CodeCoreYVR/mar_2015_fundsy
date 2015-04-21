class CampaignsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
    @campaigns = Campaign.all
  end

  def new
  end
end
