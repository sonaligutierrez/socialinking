# _3j7l   Me Gusta
# _3j7q   Me enoja
# _3j7m   Me Encanta
# _3j7r   Me Entristece
# _3j7n   Me Sorprende
# _3j7o   Me divierte
ActiveAdmin.register PostReaction do
  permit_params :name, :account_id
  menu label: proc { I18n.t("active_admin.post_reactions") }, priority: 4
  menu parent: "Posts"
  actions :all, except: [:new, :edit, :delete]
  filter :post
  index do
    column :post
    column :facebook_user
    column :reaction_icon do |post|
      div class: post.reaction
    end
    actions
  end
end
