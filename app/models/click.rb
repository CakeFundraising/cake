class Click < ActiveRecord::Base
  belongs_to :pledge, touch: true
  belongs_to :browser

  counter_culture :pledge, column_name: Proc.new {|click| click.bonus ? 'bonus_clicks_count' : 'clicks_count' },
  column_names: {
    ["clicks.bonus = ?", true] => 'bonus_clicks_count',
    ["clicks.bonus = ?", false] => 'clicks_count'
  }

  validate :browser_id, :pledge_id, presence: true
end
