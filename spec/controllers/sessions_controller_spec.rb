require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "#new" do
    before { get :new }

    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "sets a user instance variable" do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

end
