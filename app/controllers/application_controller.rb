class ApplicationController < ActionController::API
  protected

  def authenticate_user!
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.secret_key_base!).first
        @current_user = User.find(jwt_payload['sub'])
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    else
      head :unauthorized
    end
  end

  def current_user
    @current_user
  end

end
