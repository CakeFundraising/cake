module ApplicationHelper
  def active_in_page(path)
    "active" if current_page?(path)
  end

  def b(value, options = {})
    options = {
      :true => :yes,
      :false => :no,
      :scope => [:boolean],
      :locale => I18n.locale
    }.merge options

    boolean = !!value
    key = boolean.to_s.to_sym

    t(options[key], :scope => options[:scope], :locale => options[:locale])
  end

  def basic_list_item(name, value)
    content_tag(:div, class: name) do
      content_tag(:span, name)+
      content_tag(:strong, value, class:'pull-right')
    end
  end

  def auto_link(object)
    link_to object.to_s, object
  end

  def stripe_connect_button
    content_tag(:div) do
      content_tag(:h4, "Stripe Account")+
      content_tag(:div) do
        link_to user_omniauth_authorize_path(:stripe_connect), class:'stripe-connect' do
          content_tag(:span, "Connect with Stripe")
        end 
      end+ 
      content_tag(:span, "Link account to accept donations & payments thru Stripe.")
    end
  end

  def stripe_connect
    if current_fundraiser.stripe_account.blank?
      stripe_connect_button
    else
      content_tag(:div) do
        content_tag(:h4, "Stripe Account")+
        content_tag(:strong, "Account ID: ")+
        link_to(current_fundraiser.stripe_account.uid, "https://manage.stripe.com/", target: :_blank)
      end
    end
  end
end
