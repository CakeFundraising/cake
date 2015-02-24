class CakesterEmailSetting < ActiveRecord::Base
  belongs_to :user

  SETTINGS = self.column_names - ["id", "created_at", "updated_at", "user_id"]
end
