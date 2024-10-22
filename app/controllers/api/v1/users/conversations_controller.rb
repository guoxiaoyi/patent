module Api
  module V1
    class Users::ConversationsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_conversation, only: [:show]


      def index
        @conversations = @current_user.conversations.order(created_at: :desc)
        render_json(data: @conversations)
      end
      def create
        feature = Feature.find_by(feature_key: params[:feature_key])
        @conversation = @current_user.conversations.build(tenant: current_tenant, title: conversation_params[:title], feature: feature)
        @conversation.save
        render_json(data: @conversation.id)
      end

      def show
        # 获取当前用户与会话的消息
        messages = @conversation.messages.where(user_id: @current_user.id, feature_key: @conversation.feature.feature_key)
    
        # 如果已经存在处理好的消息，直接返回
        if messages.exists?
          render_json(data: { status: 'ok', content: messages.as_json(only: [:content, :feature_key])})
    
        # 如果任务正在处理中，返回任务处理中的状态
        elsif @conversation.processing?
          render_json(data: { stauts: 'pending', content: messages.as_json(only: [:content, :feature_key])})
    
        # 如果没有消息且任务未启动，启动任务并返回处理开始的状态
        else
          # 启动后台任务处理会话
          ProcessConversationJob.perform_later(@conversation.id, @current_user.id)
    
          render_json(data: { stauts: 'starting', content: messages.as_json(only: [:content, :feature_key])})
        end
      end

      def find_conversation
        @conversation = @current_user.conversations.find(params[:id])
      end
      def conversation_params
        params.require(:conversation).permit(:title)
      end
    end
  end
end
