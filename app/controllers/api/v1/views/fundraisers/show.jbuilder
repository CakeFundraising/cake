json.(@fundraiser, :id, :name, :mission, :website, :phone, :email, :manager_id, :stripe_account_uid, :stripe_account_token, :stripe_publishable_key)
json.location do
  json.(@fundraiser.location, :address, :state_code, :country_code, :city, :zip_code, :complete)
end
json.picture @fundraiser.picture