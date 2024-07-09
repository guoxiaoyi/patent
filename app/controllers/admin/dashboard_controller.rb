class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    render json: { message: 'Welcome to the admin dashboard' }
  end

  private

  def verify_admin
    unless current_user.admin?
      render json: { message: 'Access denied' }, status: :forbidden
    end
  end
end
