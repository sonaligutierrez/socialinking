require "working_url"

ActiveAdmin.register PostCreator do
  menu label: proc { I18n.t("active_admin.post_creators") }, priority: 1
  permit_params :account_id, :fan_page, :url, :avatar, :fb_user, :fb_pass, :fb_session_id, :proxy_id, :cookie_info
  config.batch_actions = false
  config.filters = false
  menu parent: "Publicadores"

  index do
    render "admin/index_post_creators", context: self
  end

  form do |f|
     f.inputs do
       f.input :account
       f.input :url
       f.input :fb_session_id, label: "fb_session", as: :select, collection: FbSession.all.map { |f| ["#{f.id}", f.id] }
     end
     f.actions
   end

  member_action :posts, method: :get do
    @post_creator = PostCreator.find(params[:id])
    @posts = Post.where(post_creator: @post_creator)
    render "admin/posts/_index_posts", context: self
  end

  show do
    attributes_table do
      row :account
      row :avatar do |ad|
        link_to ad.avatar, ad.avatar, target: "_blank"
      end
      row :url do |ad|
        link_to ad.url, ad.url, target: "_blank"
      end
    end
  end

end
