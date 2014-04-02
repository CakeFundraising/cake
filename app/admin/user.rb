ActiveAdmin.register User do

  index do |user|
    selectable_column

    column :full_name
    column :email
    column :provider
    column :uid
    column :created_at

    default_actions
  end

  filter :full_name
  filter :email
  filter :provider

  permit_params :full_name, :email, :password
end
