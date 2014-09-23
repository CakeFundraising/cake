ActiveAdmin.register Fundraiser do
  decorate_with FundraiserDecorator

  index do
    selectable_column

    column :name
    #column :mission
    #column :supporter_demographics
    column :email
    column :website
    column :phone
    column :min_pledge
    column :min_click_donation
    column :manager
    #column :manager_email
    #column :manager_phone

    default_actions
  end

  show title: proc {|fundraiser| "Fundraiser: #{fundraiser.name}" } do |fundraiser|
    attributes_table do
      row :name
      row :mission
      row :supporter_demographics
      row :causes
      row :email
      row :website
      row :phone
      row :min_pledge
      row :min_click_donation
      row :manager
      row :manager_email
      row :manager_phone
    end
  end

  filter :name
  filter :email
  filter :website
  filter :manager
  filter :campaigns
  filter :donations_kind
  filter :tax_exempt
  filter :unsolicited_pledges

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :mission
      f.input :supporter_demographics
      f.input :email
      f.input :website
      f.input :phone
      f.input :min_pledge
      f.input :min_click_donation
      f.input :donations_kind
      f.input :tax_exempt
      f.input :unsolicited_pledges

      f.input :manager
      f.input :manager_name
      f.input :manager_title
      f.input :manager_email
      f.input :manager_phone
    end

    f.actions
  end

  permit_params :name, :mission, :supporter_demographics, :email, :website, :phone, :min_pledge, :min_click_donation, :donations_kind, :tax_exempt, :unsolicited_pledges, :manager_id, :manager_name, :manager_title, :manager_email, :manager_phone
end
