ActiveAdmin.register PostComment do
  menu label: proc { I18n.t("active_admin.post_comments") }, priority: 3
  permit_params :facebook_user_id, :post_id, :category_id, :date, :comment, :id_comment, :reactions, :reactions_description, :responses, :date_comment

  index do
    column :facebook_user
    column :comment
    column :reactions_description
    column :date_comment
    column :post
    column :category
    actions
  end

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :comment
      f.input :facebook_user, label: "Usuario Facebook", as: :select, collection: FacebookUser.all.map { |u| ["#{u.fb_name}", u.id] }
      f.input :post, label: "Publicación", as: :select, collection: Post.all.map { |u| ["#{u.title}", u.id] }
      f.input :category, label: "Categoría", as: :select, collection: Category.all.map { |u| ["#{u.name}", u.id] }
      f.input :id_comment
      f.input :reactions
      f.input :reactions_description
      f.input :responses
      f.input :date_comment, as: :datetime_picker
    end
    f.actions
  end

end
