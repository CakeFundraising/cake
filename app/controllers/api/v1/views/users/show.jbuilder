json.(@user, :id)
  json.info do
    json.(@user, :full_name, :email, :roles_mask, :fundraiser_id, :sponsor_id)
  end
  if @token.present?
    json.credentials do
      json.(@token, :token)
    end
  end
  json.extra do
    if @user.fundraiser?
      json.fundraiser do
        json.(@user.fundraiser, :id, :name, :mission, :website, :phone, :email, :manager_id)
        json.location do
          json.(@user.fundraiser.location, :complete)
        end
      end
    end

    if @user.sponsor.present?
      json.sponsor do
        json.(@user.sponsor, :id, :name, :mission, :website, :phone, :email, :manager_id)
        json.location do
          json.(@user.sponsor.location, :complete)
        end
      end
    end
  end