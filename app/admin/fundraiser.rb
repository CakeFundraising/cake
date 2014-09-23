ActiveAdmin.register Fundraiser do
  decorate_with FundraiserDecorator

  index do
    selectable_column

    column :name
    #column :mission
    #column :supporter_demographics
    column :causes
    column :email
    column :website
    column :phone
    column :min_pledge
    column :min_click_donation
    column :manager
    #column :manager_email
    #column :manager_phone

    default_actions
  end

  show title: proc {|fundraiser| "Fundraiser: #{fundraiser.name}" } do |fundraiser|
    attributes_table do
      row :name
      row :mission
      row :supporter_demographics
      row :causes
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
  filter :email
  filter :website
  filter :manager
  filter :campaigns
  filter :donations_kind
  filter :tax_exempt
  filter :unsolicited_pledges

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
