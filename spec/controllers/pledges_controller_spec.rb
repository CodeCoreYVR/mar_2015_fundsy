require 'rails_helper'

RSpec.describe PledgesController, type: :controller do

  let(:user)     { create(:user)     }
  let(:campaign) { create(:campaign) }
  let(:pledge)   { create(:pledge, user: user, campaign: campaign)   }
  let(:pledge_1) { create(:pledge, campaign: campaign) }

  describe "#create" do
    context "user signed in" do
      before { login(user) }

      context "with valid params" do

        def valid_request
          post :create, campaign_id: campaign.id,
                        pledge: attributes_for(:pledge)
        end

        it "increases the number of pledges in the DB" do
          expect { valid_request }.to change { Pledge.count }.by(1)
        end

        it "associates the pledge with the logged in user" do
          valid_request
          expect(Pledge.last.user).to eq(user)
        end

        it "associates the pledge with the campaign whose id is passed" do
          valid_request
          expect(Pledge.last.campaign).to eq(campaign)
        end

        it "redirects to campaign show page" do
          valid_request
          expect(response).to redirect_to(campaign_path(campaign))
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end
      end
      context "with invalid params" do
        def invalid_request
          post :create, campaign_id: campaign.id,
                        pledge: {amount: 0}
        end

        it "doesn't increase the number of pledges in the database" do
          expect { invalid_request }.not_to change { Pledge.count }
        end

        it "renders the campaign show page" do
          invalid_request
          expect(response).to render_template("campaigns/show")
        end

        it "sets an alert flash message" do
          invalid_request
          expect(flash[:alert]).to be
        end

      end
    end
    context "user not signed in" do
      it "redirects to the user sign in page" do
        post :create, campaign_id: campaign.id, 
                      pledge: attributes_for(:pledge)
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "#destroy" do
    context "with user not signed in" do
      it "redirects to the sign in page" do
        delete :destroy, id: pledge.id,
                         campaign_id: campaign.id
        expect(response).to redirect_to new_session_path
      end
    end

    context "with user sign in" do
      before { login(user) }

      context "user is owner" do
        def valid_request
          delete :destroy, id: pledge.id,
                           campaign_id: campaign.id
        end

        it "reduces the pledge numbers in DB by 1" do
          pledge
          expect { valid_request }.to change { Pledge.count }.by(-1)
        end

        it "redirect to campaign show page" do
          valid_request
          expect(response).to redirect_to(campaign_path(campaign))
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context "user is not owner" do
        it "throws an error" do
          expect do
            delete :destroy, id: pledge_1.id,
                             campaign_id: campaign.id
          end.to raise_error
        end
      end
    end

  end

end
