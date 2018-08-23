ActiveAdmin.register FacebookUser do
  menu label: proc { I18n.t("active_admin.facebook_users") }, priority: 3
  permit_params :fb_username, :fb_name, :fb_avatar
  actions :all, except: [:new]
  filter :fb_username
  filter :fb_name
  filter :fb_avatar
  index do
    column :fb_username
    column :fb_name
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

end
