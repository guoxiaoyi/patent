class Api::V1::TenantManagers::FeaturesController < Api::V1::TenantManagers::ApplicationController
  respond_to :json

  def index
    @features = Feature.to_tree
    render_json(message: nil, data: { content: @features })
  end

  def update
    feature = Feature.find(feature_params[:id])
    if feature.update(prompt: feature_params[:prompt])
      render_json(message: nil, data: 'success')
    else
      render_json(message: feature.errors.full_messages, data: nil)
    end
  end

  private
  def feature_params
    params.require(:feature).permit(:prompt, :id)
  end
end
