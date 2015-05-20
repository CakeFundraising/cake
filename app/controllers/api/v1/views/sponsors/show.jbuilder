json.(@sponsor, :id, :name, :mission, :website, :phone, :email, :manager_id)
json.location do
  json.(@sponsor.location, :address, :state_code, :country_code, :city, :zip_code, :complete)
end
json.picture @sponsor.picture