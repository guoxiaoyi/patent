module Api
  module V1
    class Users::PaymentsController < ApplicationController
      before_action :authenticate_user!, except: [:notify]
      before_action :find_paymentable, only: [:create]
      def create
        @payment = @current_user.payments.build(tenant: current_tenant, paymentable: @paymentable, amount: @paymentable.discount)
        base_url = Rails.env.production? ? request.base_url : "https://txg-ski.club"
        if @payment.save
          options = {
            description: @paymentable.name,
            out_trade_no: @payment.code,
            amount: {
              total: (@payment.amount * 100).to_i,  # 单位: 分
              currency: 'CNY'
            }
          }
          
          begin
            wechat_pay = Pay::Wechat.new(
              method: "POST", 
              url: '/v3/pay/transactions/native', 
              body: options, 
              notify_url: "#{base_url}#{Rails.application.routes.url_helpers.notify_api_v1_users_payments_url(only_path: true)}"
            )

            @wechat_pay_response = wechat_pay.native

            if @wechat_pay_response["code_url"].nil?
              # 假设返回的错误信息在 @wechat_pay_response['message'] 中
              raise StandardError, @wechat_pay_response['message']
            end
            render :show, formats: :json
          rescue StandardError => e
            @payment.destroy
            render_json(message: e.message, status: :unprocessable_entity)
          end
        else
          render_json(data: @payment.errors, status: :unprocessable_entity)
        end
      end
      
      def notify
        body = request.raw_post
        
        # 验签失败
        unless Pay::Wechat.verify_signature(headers: request.headers, body: body)
          return render_json(code: "FAIL", message: "验签失败", status: :bad_request)
        end
      
        # 解密数据
        encrypted_data = JSON.parse(body)["resource"]
        decrypted_data = Pay::Wechat.decrypt_notification(
          nonce: encrypted_data["nonce"],
          associated_data: encrypted_data["associated_data"],
          ciphertext: encrypted_data["ciphertext"]
        )
      
        # 解密失败
        return render_json(code: "FAIL", message: "解密失败", status: :bad_request) unless decrypted_data
      
        # 查找对应的 Payment 记录
        out_trade_no = decrypted_data["out_trade_no"]
        payment = Payment.find_by(code: out_trade_no)
      
        # 未找到 Payment
        return render_json(code: "FAIL", message: "找不到对应的 #{out_trade_no} 记录", status: :not_found) unless payment
      
        # 已处理的 Payment，直接返回成功状态
        return head :ok if payment.status == 'success'
      
        # 更新 Payment 状态并返回成功状态
        payment.update(status: 'success')
        head :ok
      end
      
      private

      def find_paymentable
        @paymentable = payment_params[:paymentable_type].constantize.find(payment_params[:paymentable_id])
      end
      def payment_params
        params.require(:payment).permit(:paymentable_type, :paymentable_id)
      end

    end
  end
end
