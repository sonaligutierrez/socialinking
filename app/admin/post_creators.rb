require "working_url"

ActiveAdmin.register PostCreator do
  # menu label: proc { I18n.t("active_admin.post_creators") }, priority: 1
  permit_params :account_id, :fan_page, :url, :avatar, :fb_user, :fb_pass, :fb_session
  config.batch_actions = false

  index as: :block, class: :cards do |post_creator|
    div for: post_creator, class: :card do
      div class: "card-container" do
        h2  auto_link post_creator.fan_page
        div image_tag(post_creator.avatar) if working_url?(post_creator.avatar)
        div simple_format "#{post_creator.posts.count} Publicaciones"
      end
    end
  end


end
