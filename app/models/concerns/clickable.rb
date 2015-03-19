module Clickable
  extend ActiveSupport::Concern

  included do
    has_many :extra_clicks, -> { where(bonus: false) }, as: :clickable, class_name: 'ExtraClick', dependent: :destroy
    has_many :unique_click_browsers, through: :extra_clicks, source: :browser
  end
end