class PledgeNewsDecorator < ApplicationDecorator
  delegate_all
  decorates_association :pledge
  decorates_association :sponsor
  decorates_association :picture

  def trunc_headline
    h.truncate(object.headline, length: 37).html_safe
  end

  def trunc_story
    h.truncate(object.story, length: 100).html_safe
  end

  def to_s
    object.headline
  end

  def url
    unless object.url.blank?
      (object.url=~/^https?:\/\//).nil? ? "http://#{object.url}" : object.url
    end
  end
end