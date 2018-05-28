ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }


  content title: proc { I18n.t("active_admin.dashboard") } do
   columns do
    column do
       panel "Models" do
         ul do
           li link_to(I18n.t("active_admin.accounts"), admin_users_path)
           li link_to(I18n.t("active_admin.categories"), admin_categories_path)
           li link_to(I18n.t("active_admin.facebook_users"), admin_facebook_users_path)
           li link_to(I18n.t("active_admin.post_comments"), admin_post_comments_path)
           li link_to(I18n.t("active_admin.post_creators"), admin_post_creators_path)
           li link_to(I18n.t("active_admin.posts"), admin_posts_path)
           li link_to(I18n.t("active_admin.scraping_logs"), admin_scraping_logs_path)
           li link_to(I18n.t("active_admin.users"), admin_users_path)
         end
       end
     end
  end

   # Here is an example of a simple dashboard with columns and panels.
   #
   # columns do
   #   column do
   #     panel "Recent Posts" do
   #       ul do
   #         Post.recent(5).map do |post|
   #           li link_to(post.title, admin_post_path(post))
   #         end
   #       end
   #     end
   #   end

   #   column do
   #     panel "Info" do
   #       para "Welcome to ActiveAdmin."
   #     end
   #   end
   # end
 end # content
end
