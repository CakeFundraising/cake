class LocationsController < ApplicationController
  def subregion_options
    @parent_region ||= params[:parent_region]
    @attr_scope = params[:model] + '[location_attributes]'
    @country = Carmen::Country.coded(@parent_region)

    render partial: 'subregion_select'
  end  
end