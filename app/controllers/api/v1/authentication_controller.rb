module Api
  module V1
    class AuthenticationController < ApplicationController
      def register
        @user = User.new(user_params)

        if @user.save
          token = JWT.encode({ user_id: @user.id }, 'your_secret', 'HS256')
          render json: { token:, user: { id: @user.id, email: @user.email, name: @user.name, cpf: @user.cpf } },
                 status: :created
        else
          render json: { error: 'Failed to create user', details: @user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token: }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      private

      def user_params
        if params[:authentication]
          params.require(:authentication)
                .permit(:name, :email, :password, :cpf, :phone,
                        :cep, :street_number, :complement, :latitude, :longitude)
        else
          params.permit(:name, :email, :password, :cpf, :phone,
                        :cep, :street_number, :complement, :latitude, :longitude)
        end
      end

      def encode_token(payload)
        JWT.encode(payload, 'your_secret')
      end
    end
  end
end
