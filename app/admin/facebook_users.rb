ActiveAdmin.register FacebookUser do
  menu label: proc { I18n.t("active_admin.facebook_users") }, priority: 3
  menu parent: "Usuarios"
  permit_params :fb_username, :fb_name, :fb_avatar
  actions :all, except: [:new]
  config.filters = false
  index do
    render "admin/facebook_users/index_facebook_users", context: self
  end

  member_action :fuser_update, method: :put do
    @facebook_user = FacebookUser.find(params[:id])
    @facebook_user.update_attribute(:dni, params[:dni])
    render body: nil
  end

  collection_action :import_csv, method: :get do
   fusers = FacebookUser.all
   csv = CSV.generate(encoding: "UTF-8") do |csv|
     csv << [ "Id", "fb_username", "fb_name", "fb_avatar", "created_at", "updated_at", "dni"]
     fusers.each do |f|
       commentarry = [ f.id, f.fb_username, f.fb_name, f.fb_avatar, f.created_at,  f.updated_at, f.dni]
       csv << commentarry
     end
   end
   send_data csv.encode("UTF-8"), type: "text/csv; charset=windows-1251; header=present", disposition: "attachment; filename=facebook_users.csv"
 end

  controller do

   def index
     @fusers = FacebookUser.all.page(params[:page]).per(10)
     @page_title = "Usuarios (#{@fusers.count})"
   end
 end
end
