class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_group

  def create
    emails_array = params[:emails].split(",")
    emails_array.each do |email|
      membership = Membership.create(email: email, group: @group)
      # send membership email
    end
    render text: params
  end

  private

  def find_group
    @group = Group.find params[:group_id]
  end

end
