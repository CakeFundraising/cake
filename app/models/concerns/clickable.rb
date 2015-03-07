module Clickable
  extend ActiveSupport::Concern

  included do
    has_many :extra_clicks, -> { where(bonus: false) }, as: :clickable, class_name: 'ExtraClick', dependent: :destroy
    # has_many :bonus_extra_clicks, -> { where(bonus: true) }, as: :clickable, class_name: 'ExtraClick', dependent: :destroy
  end
end