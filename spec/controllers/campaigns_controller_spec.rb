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
          attributes = attributes_for(:campaign).merge({reward_levels_attributes: 
            {"0" => attributes_for(:reward_level)}})
          post :create, campaign: attributes
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

  describe "#update" do
    context "with user not signed in" do
      it "redirects new session path" do
        patch :update, id: campaign.id, campaign: {title: "some valid title"}
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with owner user signed in" do
      before { login(user) }

      def valid_attributes(new_attributes = {})
        attributes_for(:campaign).merge(new_attributes)
      end

      context "with valid attributes" do
          
        before do
          patch :update, id:       campaign_1.id, 
                         campaign: valid_attributes(title: "new title")
        end

        it "updates the record in the database" do
          expect(campaign_1.reload.title).to eq "new title"
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(campaign_path(campaign_1))
        end

        it "sets a flash message" do
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do
          
        before do
          patch :update, id:       campaign_1.id, 
                         campaign: valid_attributes(title: "")
        end

        it "doesn't update the record in the database" do
          expect(campaign_1.reload.title).to_not eq("")
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end

    context "with non-owner user signed in" do
      before { login(user) }

      it "raises an error" do
        expect do
          patch :update, id: campaign.id, campaign: attributes_for(:campaign)
        end.to raise_error
      end
    end
  end

  describe "#destroy" do
    context "with user signed in" do
      before { login(user) }

      context "with non-owner signed in" do
        it "throws an error" do
          expect { delete :destroy, id: campaign.id }.to raise_error
        end
      end

      context "with owner signed in" do
        it "reduces the number of campaigns in the database by 1" do
          campaign_1
          expect { delete :destroy, id: campaign_1.id }.to change { Campaign.count }.by(-1)
          # the code above essentially does the following
          # count_before = Campaign.count
          # delete :destroy, id: campaign_1.id
          # count_after  = Campaign.count
          # expect(count_after - count_before).to eq(-1)

        end

        it "redirects to the campaigns index page" do
          delete :destroy, id: campaign_1.id
          expect(response).to redirect_to campaigns_path
        end

        it "sets a flash message" do
          delete :destroy, id: campaign_1.id
          expect(flash[:notice]).to be
        end
      end
    end

    context "with user not signed in" do
      it "redirects to the sign in page" do
        delete :destroy, id: campaign.id
        expect(response).to redirect_to(new_session_path)
      end
    end

  end


end
