ActiveAdmin.register Post do
  config.filters = false
  config.batch_actions = false
  menu label: proc { I18n.t("active_admin.posts") }, priority: 2
  actions :all
  permit_params :post_creator_id, :date, :post_date, :url, :title

  index do
    render "admin/posts/index_posts", context: self
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
  member_action :comments, method: :get do
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.joins(:category).where("categories.name LIKE ?", "Uncategorized")
    @post_comments = @post_comments.page(params[:page] || 1).per(10)
  end

  member_action :new_comment, method: :get do
    @post = Post.find(params[:id])
    @post_comments = PostComment.new
    @post_comments.post = @post

  end

  member_action :create_comment, method: :post do
    @post = Post.find(params[:id])
    @post_comment = PostComment.new(comment_params)

    respond_to do |format|
      if @post_comment.save
        format.html { redirect_to comments_admin_post_path(@post), notice: "Player was successfully created." }
      else
        format.html { render action: "new_comment" }
      end
    end
  end

  collection_action :search_by_category, method: :get do
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.where(category_id: params[:category_id])
    @post_comments = @post_comments.page(params[:page] || 1).per(10)
    respond_to do |format|
      format.js
    end
  end

  collection_action :import_csv, method: :get do
    post_comments = PostComment.all.order("id ASC")
    csv = CSV.generate(encoding: "UTF-8") do |csv|
      csv << [ "Id", "Date", "Comment", "facebook User", "created_at", "updated_at",
      "category", "id_comment", "reactions", "reactions_description",
      "responses", "date_comment"]
      post_comments.each do |c|
        commentarry = [ c.id, c.date, c.comment, c.facebook_user_id, c.created_at,  c.updated_at,
        c.category.try(:name), c.id_comment, c.reactions, c.responses, c.reactions_description]
        csv << commentarry
      end
    end
    send_data csv.encode("UTF-8"), type: "text/csv; charset=windows-1251; header=present", disposition: "attachment; filename=post_comments.csv"
  end

  controller do

    def comment_params
      params.require(:post_comment).permit(:date, :comment, :facebook_user_id, :category_id, :id_comment, :reactions, :reactions_description, :responses, :date_comment)
    end
  end


end
