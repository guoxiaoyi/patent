class Api::V1::TenantManagers::UsersController < Api::V1::TenantManagers::ApplicationController
  respond_to :json
  def show
    render_json(data: {
      name: '超级管理员',
      avatar: 'https://ww4.sinaimg.cn/mw690/007cCWrJgy1ho19444w3kj30u00u040m.jpg',
      email: 'admin@example.com',
      job: 'coder',
      jobName: '董事长',
      organization: 'Frontend',
      organizationName: '前端',
      location: 'beijing',
      locationName: '北京',
      introduction: '人潇洒，性温存',
      personalWebsite: 'https://www.arco.design',
      phone: '150****0000',
      registrationDate: @current_tenant_manager.created_at,
      accountId: @current_tenant_manager.id,
      certification: 1,
      role: 'su'
    })
  end
end
