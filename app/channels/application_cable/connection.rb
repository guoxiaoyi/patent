module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      reject_unauthorized_connection unless current_user
    end

    protected

    def find_verified_user
      token = request.params[:token]
      begin
        jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base!).first
        User.find(jwt_payload['sub'])
      rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
        Rails.logger.warn "JWT authentication failed: #{e.message}"
        nil
      end
    end
  end
end
