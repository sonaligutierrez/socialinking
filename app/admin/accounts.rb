ActiveAdmin.register Account do
  permit_params :name, :url
  menu label: proc { I18n.t("active_admin.accounts") }, priority: 5
  menu parent: "Administracion"
  filter :name
  filter :url
  index do
      column :name
      column :url
      actions
    end



end
