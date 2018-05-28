ActiveAdmin.register PostCreator do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :account_id, :fan_page, :url, :avatar, :fb_user, :fb_pass, :fb_session
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
	column :account
	column :fan_page
	column :url
	column :avatar
	actions
end

end
