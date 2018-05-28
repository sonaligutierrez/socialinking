ActiveAdmin.register Post do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :post_creator_id, :date, :post_date, :url
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :date
    column :post_date
    column :post_creator
    column :url
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
