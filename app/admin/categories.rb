ActiveAdmin.register Category do
  permit_params :name, :account_id
  menu label: proc { I18n.t("active_admin.categories") }, priority: 4
  menu parent: "Administracion"
  filter :name
  index do
  	selectable_column
    column :name
    column :account
    actions
  end
end
