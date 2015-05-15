json.(@sponsor, :id, :name, :mission, :website, :phone, :email, :manager_id)
json.location do
  json.(@sponsor.location, :complete)
end
json.picture @sponsor.picture