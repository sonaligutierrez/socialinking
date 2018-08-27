ActiveAdmin.register Category do
  permit_params :name
  menu label: proc { I18n.t("active_admin.categories") }, priority: 4
  filter :name
  index do
    column :name
    column :account
    actions
  end


end
