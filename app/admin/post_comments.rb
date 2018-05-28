ActiveAdmin.register PostComment do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :facebook_user_id, :post_id, :category_id, :date, :comment, :id_comment, :reactions, :reactions_description, :responses, :date_comment
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
      column :facebook_user
      column :post
      column :category
      column :date
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
