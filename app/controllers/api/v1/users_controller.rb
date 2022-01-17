class Api::V1::UsersController < Api::V1::BaseApiController
  skip_before_action :authenticate_request!, only: :create

  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'User created successfully', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def deposit
    if deposit_param > 0 && deposit_param % 5 == 0
      balance = current_user.deposit + deposit_param
      current_user.update_attribute(:deposit, balance)
      render json: { status: 'Amount deposited successfully', user: current_user.reload }, status: :ok
    else
      render json: { errors: 'Amount should be greater than zero and multiple of 5' }, status: :unprocessable_entity
    end
  end

  private

  def deposit_param
    params[:amount].to_i
  end

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
