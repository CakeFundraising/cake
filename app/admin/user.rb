ActiveAdmin.register User do

  index do |user|
    selectable_column

    column :full_name
    column :email
    column :provider, sortable: :provider do |user|
      user.provider.titleize if user.provider.present?
    end
    column :created_at
    column :roles, sortable: :roles_mask do |user|
      user.roles.first.capitalize
    end

    default_actions
  end

  show do |user|
    attributes_table do
      row :id
      row :full_name
      row :email
      row :sign_in_count
      row :provider
      row :created_at
      row :roles do
        user.roles.first.capitalize
      end
      row :fundraiser
      row :sponsor
      bool_row :registered
    end
  end

  filter :full_name
  filter :email
  filter :provider
  filter :roles_mask, as: :select, collection: [[:Sponsor, '1'], [:Fundraiser, '2']]
  filter :registered

  permit_params :full_name, :email, :password
end
