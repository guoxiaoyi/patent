module Api
  module V1

    class Users::SessionsController < Devise::SessionsController
      respond_to :json
      before_action :check_required_params, only: :create

      def create
        user = User.find_by(phone: params[:user][:phone])
        if user&.valid_password?(params[:user][:password])
          token = generate_jwt_token(user)
          # render_json(true, 'Logged in successfully', :unprocessable_entity)
          # render json: { message: 'Logged in successfully.', token: token, user: user }, status: :ok
          render_json(message: 'Signed up successfully.', data: { token: token, user: user })
        elsif user && VerificationCode.exists?(phone: params[:user][:phone], code: params[:user][:verification_code])
          VerificationCode.find_by(phone: params[:user][:phone], code: params[:user][:verification_code]).destroy
          token = generate_jwt_token(user)
          render json: { message: 'Logged in with verification code successfully.', token: token, user: user }, status: :ok
        else
          render json: { message: 'Invalid login credentials or verification code.' }, status: :unauthorized
        end
      end

      private

      def generate_jwt_token(user)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
      def check_required_params
        required_params = [:phone, :password] # Add all required parameters here
        missing_params = required_params.select { |param| params[:user][param].blank? }

        if missing_params.any?
          render_json(message: "缺失必要参数", data: missing_params, code: 422, status: :ok)
        end
      end
    end
  end
end
