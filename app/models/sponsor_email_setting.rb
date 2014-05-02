class SponsorEmailSetting < ActiveRecord::Base
  belongs_to :sponsor

  SETTINGS = self.column_names - ["id", "created_at", "updated_at", "sponsor_id"]
end
