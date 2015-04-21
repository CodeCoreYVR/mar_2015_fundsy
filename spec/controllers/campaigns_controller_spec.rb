require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  let(:campaign)   { create(:campaign) }
  let(:campaign_1) { create(:campaign) }
  let(:user)       { create(:user)     }

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns an instance variable for all the campaigns" do
      campaign
      campaign_1
      get :index
      expect(assigns(:campaigns)).to eq [campaign, campaign_1]
    end
  end

  describe "#new" do

    context "user signed in" do
      before { login(user) }

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

    end

    context "user not signed in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end
    end
  end
end
