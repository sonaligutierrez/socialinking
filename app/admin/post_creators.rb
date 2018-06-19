require "working_url"

ActiveAdmin.register PostCreator do
  menu label: proc { I18n.t("active_admin.post_creators") }, priority: 1
  permit_params :account_id, :fan_page, :url, :avatar, :fb_user, :fb_pass, :fb_session
  config.batch_actions = false
  config.filters = false

  index do
    render "admin/index_post_creators", context: self
  end

  form do |f|
     f.inputs do
       f.input :account
       f.input :fan_page
       f.input :url
       f.input :avatar
       f.input :fb_user
       f.input :fb_pass
     end
     f.actions
   end

  show do
    attributes_table do
      row :account
      row :avatar do |ad|
        link_to ad.avatar, ad.avatar, target: "_blank"
      end
      row :fan_page do |ad|
        link_to ad.fan_page, ad.fan_page, target: "_blank"
      end
      row :url do |ad|
        link_to ad.url, ad.url, target: "_blank"
      end
      row :fb_user
    end
  end

end
