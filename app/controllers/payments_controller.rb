class PaymentsController < ApplicationController
  def invoice_payment
    @payment = Payment.new_invoice(permitted_params[:payment], current_sponsor)

    respond_to do |format|
      if @payment.save
        @payment.notify_normal_charge
        format.html{ redirect_to sponsor_billing_path, notice: 'Payment succeeded.' }
      else
        format.html{ rredirect_to sponsor_billing_path, alert: 'There was an error with your donation, please try again..' }
      end
    end
  end

  def quick_invoice_payment
    @payment = Payment.new_quick_invoice(permitted_params[:payment], current_fundraiser)

    respond_to do |format|
      if @payment.save
        @payment.notify_quick_invoice_charge
        format.html{ redirect_to fundraiser_billing_path, notice: 'Payment succeeded.' }
      else
        format.html{ rredirect_to fundraiser_billing_path, alert: 'There was an error with your donation, please try again..' }
      end
    end
  end

  def permitted_params
    params.permit(payment: [:item_id, :card_token])    
  end  
end