ActiveAdmin.register PostShared do
  permit_params :name, :account_id
  menu label: proc { I18n.t("active_admin.post_shared") }, priority: 4
  menu parent: "Posts"
  actions :all, except: [:new, :edit, :delete]
  filter :post
  index do
    column :post
    column :facebook_user
    actions
  end
end
