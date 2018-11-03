ActiveAdmin.register PostCreatorLike do
  permit_params :name, :account_id
  menu label: proc { I18n.t("active_admin.post_reactions") }, priority: 4
  menu parent: "Comentarios"
  actions :all, except: [:new, :edit, :delete]
  filter :post
  index do
    column :post
    column :facebook
    actions
  end
end
