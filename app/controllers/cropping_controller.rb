class CroppingController < ApplicationController
  def campaign_crop
    if permitted_params[:crop_x].present?
      campaign = Campaign.find params[:id]

      if permitted_params[:img_type] == 'avatar'
        campaign.picture.avatar = permitted_params[:image] #assign image to avatar
      elsif permitted_params[:img_type] == 'banner'
        campaign.picture.banner = permitted_params[:image] #assign image to banner
      end

      campaign.picture.crop_x = permitted_params[:crop_x]
      campaign.picture.crop_y = permitted_params[:crop_y]
      campaign.picture.crop_w = permitted_params[:crop_w]
      campaign.picture.crop_h = permitted_params[:crop_h]

      #campaign.send(permitted_params[:img_type]).recreate_versions! 
      campaign.save

      render text: campaign.reload.send(permitted_params[:img_type]).url(:medium) #send image url
    else
      render text: 'There was a problem with your upload. Please try again.'
    end
  end

  protected

  def permitted_params
    params.permit(
      :id,
      :crop_x,      
      :crop_y,      
      :crop_w,      
      :crop_h,
      :img_type,
      :image
    )
  end  
end