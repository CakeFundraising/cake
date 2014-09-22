ActiveAdmin.register Pledge do
  decorate_with PledgeDecorator

  index do
    selectable_column

    column :name do |pledge|
      link_to pledge.name, admin_pledge_path(pledge)
    end
    column :amount_per_click
    column :total_amount
    column :website_url do |pledge|
      link_to pledge.website_url, pledge.website_url, target: :_blank
    end
    column :max_clicks
    column :status
    column :sponsor do |pledge|
      link_to pledge.sponsor, pledge.sponsor
    end
    column :created_at

    default_actions
  end

  
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
