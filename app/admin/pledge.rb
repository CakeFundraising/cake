ActiveAdmin.register Pledge do
  decorate_with PledgeDecorator

  index do
    selectable_column

    column :name do |pledge|
      link_to pledge.name, admin_pledge_path(pledge)
    end
    column :amount_per_click
    column :total_amount
    column :website
    column :clicks_count
    column :status
    column :sponsor
    column :created_at

    default_actions
  end

  show title: proc {|pledge| "Pledge: #{pledge.name}" } do |pledge|
    attributes_table do
      row :name
      row :mission
      row :headline
      row :story
      row :website
      row :amount_per_click
      row :total_amount
      row :campaign
      row :sponsor
      row :fundraiser
      row :status
      row :clicks_count
      row :created_at
    end
  end

  filter :name
  filter :headline
  filter :website
  filter :clicks_count
  filter :campaign
  filter :sponsor
  filter :fundraiser
  filter :status, as: :select, collection: Pledge.statuses[:status].map{|s| s.to_s.titleize }.zip(Pledge.statuses[:status])
  
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
