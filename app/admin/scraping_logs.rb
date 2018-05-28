ActiveAdmin.register ScrapingLog do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :post_id, :scraping_date, :exec_time, :total_comment
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
	column :scraping_date
	column :exec_time
	column :total_comment
	column :post
end

end
