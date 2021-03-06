class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order_user.paginate page: params[:page],
      per_page: Settings.paginate.per_page
  end

  def show
    return redirect_to root_path unless @user&.activated
    @microposts = @user.microposts.order_micropost.paginate page: params[:page],
      per_page: Settings.paginate.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".flash7"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".flash2"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".flash3"
    else
      flash[:danger] = t ".flash4"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return false if logged_in?
    store_location
    flash[:danger] = t "users.flash5"
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    flash[:danger] = t "users.flash0" if @user.nil?
  end

  def correct_user
    find_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
