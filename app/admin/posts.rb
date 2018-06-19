ActiveAdmin.register Post do
  config.filters = false
  config.batch_actions = false
  menu label: proc { I18n.t("active_admin.posts") }, priority: 2

  permit_params :post_creator_id, :date, :post_date, :url, :title

  index do
    render "admin/index_posts", context: self
  end

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :title
      f.input :post_creator, label: "Publicador", as: :select, collection: PostCreator.all.map { |u| ["#{u.fan_page}", u.id] }
      f.input :url
    end
    f.actions
  end
end
