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

    actions
  end

  show title: proc {|pledge| "Pledge: #{pledge.name}" } do |pledge|
    attributes_table do
      row :name
      row :mission
      row :headline
      row :description
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
  filter :mission
  filter :website
  filter :clicks_count
  filter :campaign
  filter :sponsor
  filter :fundraiser
  filter :status, as: :select, collection: Pledge.statuses[:status].map{|s| s.to_s.titleize }.zip(Pledge.statuses[:status])


  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    f.inputs do
      f.input :name
      f.input :headline
      f.input :mission
      f.input :description
      f.input :website_url
      f.input :amount_per_click
      f.input :total_amount
      f.input :campaign
      f.input :sponsor
    end

    f.actions
  end
  
  permit_params :name, :headline, :mission, :description, :website_url, :amount_per_click, :total_amount, :campaign_id, :sponsor_id
end
