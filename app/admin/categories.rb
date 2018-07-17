ActiveAdmin.register Category do
  permit_params :name

  filter :name
  index do
    column :name
    column :account
    actions
  end


end
