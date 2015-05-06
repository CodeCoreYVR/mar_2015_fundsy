class Api::V1::BaseController  < ApplicationController
  before_action :authorize
  skip_before_action :verify_authenticity_token

  private

  def authorize
    @user = User.find_by_api_key params[:api_key]
    # this will halt the request and send a 401 HTTP response
    head :unauthorized unless @user
  end

end
