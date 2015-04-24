require 'rails_helper'

RSpec.feature "Campaigns", type: :feature do
  describe "Home Page" do
    it "displays a welcome message" do
      visit root_path
      expect(page).to have_text "Welcome to Fund.sy"
    end

    it "dispalys a title for the page" do
      visit root_path
      expect(page).to have_title "Fund.sy - Crowdfunding for the awesome"
    end

    context "with campaigns created" do
      let!(:campaign)   { create(:campaign) }
      let!(:campaign_1) { create(:campaign) }

      it "displays the title of the campaign" do
        visit root_path
        expect(page).to have_text /#{campaign.title}/i
      end

      it "displays campaign titles in h2 elements" do
        visit root_path
        expect(page).to have_selector("h2", /#{campaign.title}/i)
      end

    end

  end
end
