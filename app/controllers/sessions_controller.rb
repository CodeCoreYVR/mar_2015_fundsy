class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email params[:user][:email]
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash[:alert] = "Wrong Credentials"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    render nothing: true
  end
end
