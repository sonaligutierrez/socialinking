ActiveAdmin.register FacebookUser do
  menu label: proc { I18n.t("active_admin.facebook_users") }, priority: 3
  menu parent: "Usuarios"
  permit_params :fb_username, :fb_name, :fb_avatar
  actions :all, except: [:new]
  filter :posts, label: "Publicaciones"
  filter :post_creators, label: "Publicadores"
  index do
    column :fb_username
    column :fb_name
    column :dni do |fuser|
      text_field_tag "dni", fuser.dni, maxlength: 15, size: 20, class: "dni-input", onchange: "update_dni(#{fuser.id}, this.value)"
    end
    column :fb_avatar do |img|
      image_tag img.fb_avatar unless img.fb_avatar.to_s.empty?
    end
    column "Actions" do |u|
      col = link_to "Ver", admin_facebook_user_path(u)
      if current_user.admin?
        col += link_to "Editar", edit_admin_facebook_user_path(u)
        col += link_to "Eliminar", admin_facebook_user_path(u), method: :DELETE
      end
      col
    end
  end

  member_action :fuser_update, method: :put do
    @facebook_user = FacebookUser.find(params[:id])
    @facebook_user.update_attribute(:dni, params[:dni])
    render body: nil
  end

end
