class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    verification_code = VerificationCode.find_by(phone: sign_up_params[:phone], code: params[:user][:verification_code])
    if verification_code.nil?
      render json: { errors: ['Invalid verification code'] }, status: :unprocessable_entity
    else
      build_resource(sign_up_params)
      resource.save
      if resource.persisted?
        verification_code.destroy
        render json: { message: 'Signed up successfully.' }, status: :ok
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:phone, :password, :password_confirmation)
  end
end
