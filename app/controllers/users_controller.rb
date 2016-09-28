class UsersController < ApplicationController
  def profile
  end

  def update
    if current_user.update(user_params)
      redirect_to root_url
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
