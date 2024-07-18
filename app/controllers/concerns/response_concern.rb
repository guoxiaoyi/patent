module ResponseConcern
  extend ActiveSupport::Concern

  def render_json( message:, code: 0, status: :ok, data: {})
    render json: { code: code, message: message, data: data }, status: status
  end

end
