require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  let(:user)       { create(:user)     }
  let(:campaign)   { create(:campaign) }
  let(:campaign_1) { create(:campaign, user: user) }

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

      it "set a instance variable to a new campaign" do
        get :new
        expect(assigns(:campaign)).to be_a_new Campaign
      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "#create" do

    context "user signed in" do
      before { login(user) }

      context "with valid parameters" do
        def valid_request
          post :create, campaign: attributes_for(:campaign)
        end

        it "creates a new campaign in the database" do
          expect { valid_request }.to change { Campaign.count }.by(1)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "redirect to campaign show page" do
          valid_request
          expect(response).to redirect_to(campaign_path(Campaign.last))
        end

        it "associates the created campaign to the user" do
          valid_request
          expect(Campaign.last.user).to eq(user)
        end
      end

      context "with invalid parameters" do
        def invalid_request
          post :create, campaign: {goal: 1}
        end

        it "doesn't create a record in the database" do
          expect { invalid_request }.to change { Campaign.count }.by(0)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "sets a flash message" do
          invalid_request
          expect(flash[:alert]).to be
        end

      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        post :create, campaign: attributes_for(:campaign)
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "#show" do
    before { get :show, id: campaign.id }

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "sets an instance variable with the campaign whose id is passed" do
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "#edit" do

    context "user not signed in" do
      before { get :edit, id: campaign.id }

      it "redirects to sign in page" do
        expect(response).to redirect_to new_session_path
      end
    end

    context "owner user signed in" do
      before { login(user) }
      before { get :edit, id: campaign_1.id }

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

      it "sets a campaign instance variable with the id passed" do
        expect(assigns(:campaign)).to eq(campaign_1)
      end
    end

    context "with non-owner user signed in" do
      before { login(user) }

      it "raises an error if a non-owners tries to edit" do
        # campaign doesn't have :user option passed to it
        # this means a user will be created that is different from 
        # "user" we created with the factory and logged in
        expect { get :edit, id: campaign.id }.to raise_error
      end
    end
  end

end
