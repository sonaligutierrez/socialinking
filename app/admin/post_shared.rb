ActiveAdmin.register PostShared do
  permit_params :name, :account_id
  menu label: proc { I18n.t("active_admin.post_shared") }, priority: 4
  menu parent: "Administracion"
  actions :all, except: [:new, :edit, :delete]
  filter :post
  index do
    selectable_column
    column :post
    column :facebook_user
    actions
  end
end
