ActiveAdmin.register Campaign do
  decorate_with CampaignDecorator

  index do
    selectable_column

    column :title
    column 'Main Cause', :main_cause
    column :end_date
    column :status
    column 'Pledge Levels', :custom_pledge_levels
    column :average_pledge

    default_actions
  end

  show title: proc {|campaign| "Campaign: #{campaign.title}" } do |campaign|
    attributes_table do
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

  filter :title
  filter :main_cause
  filter :launch_date
  filter :end_date
  filter :status, as: :select, collection: Campaign.statuses[:status].map{|s| s.to_s.titleize }.zip(Campaign.statuses[:status])
  filter :fundraiser
  filter :sponsors
  filter :custom_pledge_levels


  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    f.inputs do
      f.input :title
      f.input :launch_date, as: :string, input_html:{class: 'datepicker'}
      f.input :end_date, as: :string, input_html:{class: 'datepicker'}
      f.input :headline
      f.input :story
      f.input :mission
      f.input :main_cause, as: :select, collection: Campaign::CAUSES
      f.input :scopes, as: :check_boxes, collection: Campaign::SCOPES
      #f.input :scopes, as: :select, collection: Campaign::SCOPES
      f.input :goal
      f.input :fundraiser
    end

    f.actions
  end

  permit_params :title, :launch_date, :end_date, :headline, :story, :mission, :main_cause, :goal, :fundraiser_id, scopes: []
end
