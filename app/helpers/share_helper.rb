module ShareHelper
  def facebook_button(url)
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

  def others_share_button
    content_tag(:button, class:'btn btn-default popover_button', data:{toggle:'popover', content: 'Some content here...'}) do
      content_tag(:span, nil, class:'glyphicon glyphicon-transfer')
    end
  end
end