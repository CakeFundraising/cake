class FundraiserEmailSetting < ActiveRecord::Base
  belongs_to :fundraiser

  SETTINGS = self.column_names - ["id", "created_at", "updated_at", "fundraiser_id"]
end
