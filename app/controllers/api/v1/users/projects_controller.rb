module Api
  module V1
    class Users::ProjectsController < ApplicationController
      before_action :find_project, only: [:update, :destroy]
      def index
        @projects = current_tenant.projects.page(params[:page]).per(params[:per_page] || 10)
        render :index, formats: :json
        # render_json(message: nil, data: { 
        #   content: @projects,
        #   pagination: pagination_meta(@projects)
        # })
      end

      def create
        @project = current_tenant.projects.build(project_params)
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
        params.require(:project).permit(:name, :customer_id)
      end

      def find_project
        @project = current_tenant.projects.find(params[:id])
      end
    end
  end
end
