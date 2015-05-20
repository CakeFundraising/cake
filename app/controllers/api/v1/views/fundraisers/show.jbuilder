json.(@fundraiser, :id, :name, :mission, :website, :phone, :email, :manager_id)
json.location do
  json.(@fundraiser.location, :address, :state_code, :country_code, :city, :zip_code, :complete)
end
json.picture @fundraiser.picture