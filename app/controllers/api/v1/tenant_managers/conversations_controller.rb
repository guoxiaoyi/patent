class Api::V1::TenantManagers::ConversationsController < Api::V1::TenantManagers::ApplicationController
  respond_to :json

  def index
    @conversations = Conversation.all.order(created_at: :desc)
    render_json(message: nil, data: {content: @conversations.as_json(include: {user: {only: [:phone]}, feature: {only: [:name]}})})
  end
end
