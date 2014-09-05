class CroppingController < ApplicationController
  def crop
    if permitted_params[:crop_x].present?
      model = permitted_params[:model].camelize.constantize.find params[:id]

      model.picture.crop_x = permitted_params[:crop_x]
      model.picture.crop_y = permitted_params[:crop_y]
      model.picture.crop_w = permitted_params[:crop_w]
      model.picture.crop_h = permitted_params[:crop_h]

      if permitted_params[:img_type] == 'avatar'
        model.picture.avatar = permitted_params[:image] #assign image to avatar
      elsif permitted_params[:img_type] == 'banner'
        model.picture.banner = permitted_params[:image] #assign image to banner
      end

      model.save

      render text: model.reload.send(permitted_params[:img_type]).url(:medium) #send image url
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
      :model,
      :image
    )
  end  
end