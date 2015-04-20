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
      it "creates a user in the database" do
        # this will call User.count before what's inside the expect block
        # which is in this case (post :create ...)
        # then it will call "User.count" after that.
        # it will take: count after - count before
        # and compare it to the value you gave (in this case 1)
        expect do
          post :create, {user: {
                          first_name: "Tam",
                          last_name: "Kbeili",
                          email: "tam@codecore.ca",
                          password: "abcd1234",
                          password_confirmation: "abcd1234"
                        }}
        end.to change { User.count }.by(1)

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

    end

    context "with invalid parameters" do

    end
  end
end
