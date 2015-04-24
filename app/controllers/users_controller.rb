class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      Membership.pending.where(email: @user.email).each do |m|
        m.approved = true
        m.user     = @user
        m.save
      end
      flash[:notice] = "Account created!"
      redirect_to root_path
    else
      flash[:alert] = "Account wasn't created!"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                  :password, :password_confirmation)
  end
end
