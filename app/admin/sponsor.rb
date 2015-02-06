ActiveAdmin.register Sponsor do
  decorate_with SponsorDecorator

  before_create do |sponsor|
    sponsor.build_location(resource_params.first['location_attributes'])
  end

  index do
    selectable_column

    column :name
    column :email
    column :website
    column :company_name
    column :phone
    column :manager

    actions
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

    panel 'Location' do
      attributes_table_for sponsor.location do
        row :address
        row :zip_code
        row :city
        row :country_code
        row :state_code
      end
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

    f.inputs 'Location' do
      f.semantic_fields_for :location do |l|
        l.inputs :address, :zip_code, :city, :country_code, :state_code
      end
    end

    f.actions
  end
  
  permit_params :name, :mission, :customer_demographics, :email, :website, :phone, 
  :manager_id, :manager_name, :manager_title, :manager_email, :manager_phone,
  location_attributes: [:address, :city, :zip_code, :state_code, :country_code]
end
