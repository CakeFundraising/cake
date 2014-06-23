module ShareHelper
  def facebook_button(url)
    content_tag(:div, nil, id:'fb-root')+
    content_tag(:div, nil, class:'fb-share-button', data: {href: url, type: "button_count"})
  end

  def twitter_button(text)
    %Q{<iframe allowtransparency="true" frameborder="0" scrolling="no" src="https://platform.twitter.com/widgets/tweet_button.html?text=#{text}" style="width:78px; height:20px;"></iframe>}.html_safe
  end

  def email_button(subject, body)
    mail_to nil, subject: subject, body: body, class:'btn btn-danger' do
      content_tag(:span) do
        concat(
          content_tag(:span, nil, class:'glyphicon glyphicon-envelope')
        )+
        concat(
          content_tag(:span, ' Email')
        )
      end
    end
  end

  def other_social_buttons
    buttons = content_tag(:div) do
      render_shareable buttons: ['google_plus', 'pinterest', 'linkedin', 'reddit']
    end.html_safe
    "#{buttons}"
  end

  def copy_url(id, value)
    copy = content_tag(:div) do
      content_tag(:input, nil, id: id, disabled:'', class:'form-control', type:'text', value: value)+
      content_tag(:button, 'Copy', class:'clipboard btn btn-default', data:{:'clipboard-target' => id })
    end.html_safe
    "#{copy}"
  end

  def others_share_button(id, value)
    content = other_social_buttons + copy_url(id, value)
    content_tag(:button, class:'btn btn-default popover_button', data:{toggle:'popover', content: content }) do
      content_tag(:span, nil, class:'glyphicon glyphicon-transfer')
    end
  end
end