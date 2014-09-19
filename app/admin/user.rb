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

  filter :full_name
  filter :email
  filter :provider
  filter :roles_mask, as: :select, collection: [[:Sponsor, '1'], [:Fundraiser, '2']]
  filter :registered

  permit_params :full_name, :email, :password
end
