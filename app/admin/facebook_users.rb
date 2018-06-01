ActiveAdmin.register FacebookUser do
  menu :label => proc { I18n.t("active_admin.facebook_users") }, :priority => 4
  permit_params :fb_username, :fb_name, :fb_avatar

  index do
      column :fb_username
      column :fb_name
      column :fb_avatar
      actions
    end

end
