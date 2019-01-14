ActiveAdmin.register PostComment do
  permit_params :facebook_user_id, :post_id, :category_id, :date, :comment, :id_comment, :reactions, :reactions_description, :responses, :date_comment, :id_comment
  menu false
  menu label: proc { I18n.t("active_admin.categorize") }, priority: 3
  config.filters = false
  config.clear_action_items!
  actions :all

  index  do
    render "admin/posts/comments", context: self
  end

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :comment
      f.input :facebook_user, label: "Usuario Facebook", as: :select, collection: FacebookUser.all.map { |u| ["#{u.fb_name}", u.id] }
      f.input :post, label: "Publicación", as: :select, collection: Post.all.map { |u| ["#{u.title}", u.id] }
      f.input :category, label: "Categoría", as: :select, collection: Category.all.map { |u| ["#{u.name}", u.id] }
      f.input :id_comment
      f.input :reactions
      f.input :reactions_description
      f.input :responses
      f.input :date_comment, as: :datetime_picker
    end
    f.actions
  end

  member_action :categorize_comment, method: :put do
    @post_comment = PostComment.find(params[:id])
    @post_comment.update_attribute(:category_id, params[:category_id])
    @id = params[:id]
    render body: nil
  end

  collection_action :import_csv, method: :get do
    post = Post.find(params[:post_id])
    post_comments = !post.nil? ? post.post_comments : PostComment.where(post_id: params[:post_id]).includes(:facebook_user).order("id ASC")
    csv = CSV.generate(encoding: "UTF-8") do |csv|
      csv << [ "Id", "Date", "Comment", "facebook User", "created_at", "updated_at",
      "category", "id_comment", "reactions", "reactions_description",
      "responses", "date_comment"]
      post_comments.each do |c|
        commentarry = [ c.id, c.date, c.comment, c.facebook_user&.name, c.created_at,  c.updated_at,
        c.category.try(:name), c.id_comment, c.reactions, c.responses, c.reactions_description]
        csv << commentarry
      end
    end
    send_data csv.encode("UTF-8"), type: "text/csv; charset=windows-1251; header=present", disposition: "attachment; filename=post_comments.csv"
  end

  collection_action :filter_comments, method: :get do
    @q = PostComment.new
    @categories = Category.all
  end

  collection_action :search_comments, method: :get do
    @post_comments = PostComment.search(params[:post_comment])
    @post_comments = @post_comments.page(params[:page] || 1).per(10)
    @categorias = Category.content_select
    respond_to do |format|
      format.js
    end
  end



  action_item :only => :index do
    #link_to "Filtrar comentarios", filter_comments_admin_post_comments_path, remote: true
  end
  action_item :only => :index do
    link_to "Añadir comentarios", new_admin_post_comment_path
  end



  controller do
    def index
      @post = params[:post_id].nil? ? nil : Post.find(params[:post_id])
      @post_comments = @post.nil? ? PostComment.all : @post.post_comments
      @post_comments = @post_comments.page(params[:page] || 1).per(10)
      @page_title = @post.nil? ? "Categorizar" : @post.try(:title)
      @categorias = Category.content_select
    end
  end

end
