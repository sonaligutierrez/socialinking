ActiveAdmin.register Category do
  permit_params :name, :account_id
  menu label: proc { I18n.t("active_admin.categories") }, priority: 4
  menu parent: "Comentarios"
  filter :name
  index do
    column :name
    column :account
    actions
  end
end
