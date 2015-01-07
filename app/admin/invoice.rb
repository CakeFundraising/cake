ActiveAdmin.register Invoice do
  decorate_with InvoiceDecorator

  index do
    selectable_column

    column :invoice do |invoice|
      link_to "##{invoice.id}", admin_invoice_path(invoice)
    end
    column :pledge
    column :clicks
    column :click_donation
    column :due
    column :status

    actions
  end

  filter :id
  filter :clicks
  filter :status, as: :select, collection: Invoice.statuses[:status].map{|s| s.to_s.titleize }.zip(Invoice.statuses[:status])
  filter :pledge
  filter :sponsor

  show do |invoice|
    attributes_table do
      row :clicks
      row :click_donation
      row :due
      row :status
      row :pledge
      row :sponsor
      row :campaign
      row :fundraiser
      row :created_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    
    f.inputs do
      f.input :clicks
      f.input :click_donation
      f.input :due
      f.input :status, as: :select, collection: Invoice.statuses[:status].map{|s| s.to_s.titleize }.zip(Invoice.statuses[:status])
      f.input :pledge
    end

    f.actions
  end

  permit_params :clicks, :click_donation, :due, :status, :pledge_id
end
