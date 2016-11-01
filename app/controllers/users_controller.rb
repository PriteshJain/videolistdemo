class UsersController < ApplicationController
  before_action :validate_app_token, only: [:generate_otp, :authenticate_otp, :create]
  skip_before_filter :validate_api_token, only: [:generate_otp, :authenticate_otp]
  before_action :set_user_service, only: [:show, :update, :create, :generate_otp, :authenticate_otp]
  before_action :set_user, only: [:show, :update]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    user = @user_service.create!
    if user.persisted?
      render json: user, status: :created, location: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def generate_otp
    user = @user_service.generate_otp
    if user.persisted?
      render json: {status: :success}
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def regenerate_otp
    user = @user_service.regenerate_otp
    if user.persisted?
      render json: {status: :success}
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def authenticate_otp
    @user = @user_service.authenticate_otp(signin_params)
    if @user.active?
      render 'show.json'
    else
      render json: bad_request_json(message: 'OTP is invalid'), status: :bad_request
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user = @user_service.update!
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = @user_service.find(user_params[:id])
    end

    def set_user_service()
      @user_service = UserService.new(user_params)
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :mobile_no, :email)
    end

    def signin_params
      params.require(:user).permit(:mobile_no, :otp)
    end

    def validate_app_token
      if !params[:appkey].eql?(ENV['APP_KEY'])
        return(render(json: bad_request_json(message: "invalid request"), status: :bad_request))
      end
    end
end
