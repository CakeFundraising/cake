json.(@fundraiser, :id, :name, :mission, :website, :phone, :email, :manager_id)
json.location do
  json.(@fundraiser.location, :complete)
end
json.picture @fundraiser.picture