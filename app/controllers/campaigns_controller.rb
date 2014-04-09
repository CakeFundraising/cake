class CampaignsController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: :update

  def permitted_params
    params.permit(campaign: [:title, :launch_date, :end_date, :story, :show_donation, :cause, :headline, 
    picture_attributes: [:banner, :avatar, :avatar_caption], sponsor_categories_attributes: [:id, :name, :min_value, :max_value, :_destroy] ])
  end

  private 

  def build_resource
    if resource_params.present?
      @campaign = current_fundraiser.campaigns.build(*resource_params)  
    else
      @campaign = current_fundraiser.campaigns.build  
    end
  end
end
