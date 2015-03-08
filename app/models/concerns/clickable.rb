module Clickable
  extend ActiveSupport::Concern

  included do
    has_many :extra_clicks, -> { where(bonus: false) }, as: :clickable, class_name: 'ExtraClick', dependent: :destroy
  end
end