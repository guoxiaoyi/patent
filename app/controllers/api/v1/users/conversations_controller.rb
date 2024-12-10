module Api
  module V1
    class Users::ConversationsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_conversation, only: [:show, :generate_document]

      def index
        @q = @current_user.conversations.ransack(feature_feature_key_eq: Feature.feature_keys[params[:feature_id]])
        @conversations = @q.result.order(created_at: :desc)

        render_json(data: @conversations)
      end
      def create
        feature = Feature.find_by(feature_key: conversation_params[:feature_id])
        project = Project.find(params[:project_id])
        @conversation = Conversation.new(title: conversation_params[:title], user: @current_user, tenant: @current_user.tenant, feature: feature, project: project)

        if @conversation.save
          render_json(data: @conversation.request_id)
        else
          render_json(message: '余额不足,请充值', status: :unprocessable_entity)
        end
      end

      def show
        # 获取当前用户与会话的消息
        @messages = @conversation.messages.where(user_id: @current_user.id, feature_key: @conversation.feature.feature_key)
        
        @status = "pending"
        # 如果已经存在处理好的消息，直接返回
        if @conversation.processing?
          # 如果任务正在处理中，返回任务处理中的状态
          @status = "pending"
        elsif @messages.exists?
          # 如果没有消息且任务未启动，启动任务并返回处理开始的状态
          @status = "ok"
        else
          # 启动后台任务处理会话
          @conversation.feature.use(@conversation)
          @status = "starting"
        end
        render :show, formats: :json
      end

      def generate_document
        template_path = Rails.root.join('config', 'templates', 'write_application.docx')
        output_path = Rails.root.join('public', 'output.docx')
    
        # 调用服务生成 Word 文档
        
        generator = DocxTemplateService.new(@conversation.messages, template_path)
        generator.generate(output_path)
    
        # 让用户下载生成的文档
        send_file output_path, type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', filename: 'output.docx'      end
      
      def find_conversation
        @conversation = @current_user.conversations.find_by(request_id: params[:id])
      end
      def conversation_params
        params.require(:conversation).permit(:title, :project_id, :feature_id)
      end
    end
  end
end
