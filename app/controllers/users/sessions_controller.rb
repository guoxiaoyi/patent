class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_by(phone: params[:user][:phone])
    if user&.valid_password?(params[:user][:password])
      token = generate_jwt_token(user)
      render json: { message: 'Logged in successfully.', token: token, user: user }, status: :ok
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
end
