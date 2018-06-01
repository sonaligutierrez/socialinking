ActiveAdmin.register Post do

  menu label: proc { I18n.t("active_admin.posts") }, priority: 2

  permit_params :post_creator_id, :date, :post_date, :url

  index do
    column :post_creator
    column :url
    column :title
    actions
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
