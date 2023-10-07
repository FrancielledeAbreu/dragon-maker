class Api::V1::UsersController < AuthenticatedController
  def show
    user = current_user
    render json: user, status: :ok
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { error: 'Failed to update user', details: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user = current_user

    if user.authenticate(params[:password])
      user.destroy
      render json: { message: 'User and all associated data deleted successfully' }, status: :ok
    else
      render json: { error: 'Incorrect password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :cpf, :phone, :cep, :street_number, :complement, :latitude, :longitude)
  end
end
