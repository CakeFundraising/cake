class PaymentsController < ApplicationController
  def invoice_payment
    @payment = Payment.new(permitted_params[:payment])        
    @payment.payer = current_sponsor
    @payment.recipient = @payment.item.fundraiser
    @payment.kind = 'invoice_payment'

    respond_to do |format|
      if @payment.save
        format.html{ redirect_to sponsor_billing_path, notice: 'Payment succeeded.' }
      else
        format.html{ rredirect_to sponsor_billing_path, alert: 'There was an error with your donation, please try again..' }
      end
    end
  end

  def permitted_params
    params.permit(payment: [:item_type, :item_id, :total_cents, :card_token])    
  end  
end