class Api::V1::TenantManagers::SubFeaturesController < Api::V1::TenantManagers::ApplicationController
  respond_to :json
  def update
    sbu_feature = Feature.find(sub_feature_params[:feature_id]).sub_features.find(sub_feature_params[:id])
    if sbu_feature.update(prompt: sub_feature_params[:prompt], sort_order: sub_feature_params[:sort_order])
      render_json(message: nil, data: 'success')
    else
      render_json(message: sbu_feature.errors.full_messages, data: nil)
    end
  end

  private
  def sub_feature_params
    params.require(:sub_feature).permit(:prompt, :id, :feature_id, :sort_order)
  end
end
