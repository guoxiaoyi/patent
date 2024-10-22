module Api
  module V1
    class Users::ProjectsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_project, only: [:update, :destroy]
      def index
        @q = @current_user.projects.ransack(params[:q])
        @projects = @q.result.page(params[:page]).per(params[:per_page] || 10)
        render :index, formats: :json
      end

      def create
        @project = @current_user.projects.build(project_params)
        @project.tenant = current_tenant
        if @project.save
          render_json(data: @project)
        else
          render_json(data: @project.errors, status: :unprocessable_entity)
        end
      end
      def update
        if @project.update(project_params) 
          render_json(data: @project)
        else
          render_json(data: @project, status: :unprocessable_entity)
        end
      end

      def destroy
        if @project.destroy
          render_json(data: nil)
        else
          render_json(data: nil, status: :error)
        end
      end

      private

      def project_params
        params.require(:project).permit(:name, :customer_id, :created_at)
      end

      def find_project
        @project = @current_user.projects.find(params[:id])
      end
    end
  end
end
