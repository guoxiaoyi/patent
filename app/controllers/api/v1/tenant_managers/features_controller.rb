class Api::V1::TenantManagers::FeaturesController < Api::V1::TenantManagers::ApplicationController
  respond_to :json

  def index
    @features = Feature.to_tree
    render_json(message: nil, data: { content: @features })
  end
end
