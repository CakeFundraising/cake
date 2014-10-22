module FundraisersHelper
  def stripe_connect_button
    content_tag(:div) do
      content_tag(:div) do
        link_to user_omniauth_authorize_path(:stripe_connect), class:'stripe-connect' do
          content_tag(:span, "Connect with Stripe")
        end 
      end
      #end+ 
      #content_tag(:span, "Link account to accept donations & payments thru Stripe.", class: 'link-stripe-account')
    end
  end

  def stripe_buttons
    account = current_user.fundraiser || current_user.sponsor

    if account.stripe_account?
      go_to_stripe
    else
      stripe_connect_button
    end
  end

  def go_to_stripe
    link_to "https://manage.stripe.com/", target: :_blank, class: 'stripe-connect' do
      content_tag(:span, "Go to Stripe")
    end
  end
end
