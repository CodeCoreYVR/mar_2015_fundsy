require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "#new" do
    it "instantiates a new user variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do

    context "with valid parameters" do
      def valid_request
          post :create, {user: {
                          first_name: "Tam",
                          last_name: "Kbeili",
                          email: "tam@codecore.ca",
                          password: "abcd1234",
                          password_confirmation: "abcd1234"
                        }}
      end

      it "creates a user in the database" do
        # this will call User.count before what's inside the expect block
        # which is in this case (post :create ...)
        # then it will call "User.count" after that.
        # it will take: count after - count before
        # and compare it to the value you gave (in this case 1)
        expect { valid_request }.to change { User.count }.by(1)

        # before_count = User.count
        # post :create, {user: {
        #                 first_name: "Tam",
        #                 last_name: "Kbeili",
        #                 email: "tam@codecore.ca",
        #                 password: "abcd1234",
        #                 password_confirmation: "abcd1234"
        #               }}
        # after_count = User.count
        # difference = after_count - before_count
        # expect(difference).to eq(1)
      end

      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end

      it "redirects to the root path of the application" do
        valid_request
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      def invalid_request
          post :create, {user: {
                          password: "abcd1234",
                          password_confirmation: "abcd1234"
                        }}
      end

      it "doesn't create a user record in the database" do
        expect { invalid_request }.to_not change { User.count }
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "sets an alert flash message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end
end
