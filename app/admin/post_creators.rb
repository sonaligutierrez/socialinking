ActiveAdmin.register PostCreator do
  menu label: proc { I18n.t("active_admin.post_creators") }, priority: 1
  permit_params :account_id, :fan_page, :url, :avatar, :fb_user, :fb_pass, :fb_session

  index do
    column :account
    column :fan_page
    column :url
    column :avatar
    actions
  end

end
