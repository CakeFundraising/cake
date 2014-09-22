ActiveAdmin.register Campaign do
  decorate_with CampaignDecorator

  index do
    selectable_column

    column :title
    column 'Main Cause', :main_cause
    #column 'Launch Date', :launch_date
    #column :created_at
    column :end_date
    column :status
    column 'Pledge Levels', :custom_pledge_levels
    column :average_pledge

    default_actions
  end

  show title: proc {|campaign| "Campaign: #{campaign.title}" } do |campaign|
    attributes_table do
      row :id
      row :title
      row :mission
      row :main_cause
      row :goal
      row :launch_date
      row :end_date
      row :headline
      row :story
      row :created_at
      row :causes
      row :scopes
      row :status
      bool_row :custom_pledge_levels
      row :fundraiser
    end
  end

  filter :fundraiser
  filter :sponsors
  filter :name
  filter :main_cause
  filter :launch_date
  filter :end_date
  filter :status, as: :select, collection: Campaign.statuses[:status].map{|s| s.to_s.titleize }.zip(Campaign.statuses[:status])
  filter :custom_pledge_levels

  # permit_params :list, :of, :attributes, :on, :model
end
