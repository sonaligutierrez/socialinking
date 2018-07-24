ActiveAdmin.register FacebookUser do
  menu label: proc { I18n.t("active_admin.facebook_users") }, priority: 4
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
    actions
  end

end
