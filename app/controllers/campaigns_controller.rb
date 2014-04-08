class CampaignsController < InheritedResources::Base
  def permitted_params
    params.permit(campaign: [:title, :launch_date, :end_date, :story, :show_donation, :cause, :headline, 
    picture_attributes: [:banner, :avatar, :avatar_caption] ])
  end
end
