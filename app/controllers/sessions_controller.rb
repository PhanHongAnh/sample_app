class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = t ".flash"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
