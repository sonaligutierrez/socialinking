ActiveAdmin.register PostComment do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :facebook_user_id, :post_id, :category_id, :date, :comment, :id_comment, :reactions, :reactions_description, :responses, :date_comment
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
    column :facebook_user
    column :post
    column :category
    column :date
    actions 
  end

end
