ActiveAdmin.register Sponsor do
  decorate_with SponsorDecorator

  index do
    selectable_column

    column :name
    column :causes
    column :email
    column :website
    column :company_name
    column :phone
    column :manager

    default_actions
  end

  show title: proc {|sponsor| "Sponsor: #{sponsor.name}" } do |sponsor|
    attributes_table do
      row :name
      row :mission
      row :supporter_demographics
      row :causes
      row :scopes
      row :company_name
      row :company_phone
      row :email
      row :website
      row :phone
      row :min_pledge
      row :min_click_donation
      row :manager
      row :manager_email
      row :manager_phone
    end
  end

  filter :name
  filter :company_name
  filter :email
  filter :website
  filter :manager
  filter :pledges
  filter :campaigns
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
