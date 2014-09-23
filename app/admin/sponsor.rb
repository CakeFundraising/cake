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
      row :customer_demographics
      row :causes
      row :scopes
      row :email
      row :website
      row :phone
      row :manager
      row :manager_email
      row :manager_phone
    end
  end

  filter :name
  filter :email
  filter :website
  filter :manager
  filter :pledges
  filter :campaigns

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :mission
      f.input :customer_demographics
      f.input :email
      f.input :website
      f.input :phone

      f.input :manager
      f.input :manager_name
      f.input :manager_title
      f.input :manager_email
      f.input :manager_phone
    end

    f.actions
  end
  
  permit_params :name, :mission, :customer_demographics, :email, :website, :phone, :manager_id, :manager_name, :manager_title, :manager_email, :manager_phone
end
