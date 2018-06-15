ActiveAdmin.register Post do
  menu label: proc { I18n.t("active_admin.posts") }, priority: 2
  actions :all
  permit_params :post_creator_id, :date, :post_date, :url, :title

  index do
    column :post_creator
    column :url
    column :title
    actions
    actions do |resource|
        link_to(I18n.t("active_admin.post_comments"), comments_admin_post_path(resource), method: :get)
      end

  end

  form do |f|
   f.inputs do
     f.input :date, as: :datepicker
     f.input :title
     f.input :post_creator, label: I18n.t("active_admin.fb_user"), as: :select, collection: PostCreator.all.map { |u| ["#{u.fan_page}", u.id] }
     f.input :url
   end
   f.actions
  end
  member_action :comments, method: :get do
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.joins(:category).where("categories.name LIKE ?",'Uncategorized')
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
        format.html { redirect_to comments_admin_post_path(@post), notice: 'Player was successfully created.' }
      else
        format.html { render action: 'new_comment' }
      end
    end
  end

  collection_action :search_by_category, method: :get do
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.where(category_id: params[:category_id])
    respond_to do |format|
      format.js
    end
  end 

  controller do

    def comment_params
      params.require(:post_comment).permit(:date, :comment, :facebook_user_id, :category_id, :id_comment, :reactions, :reactions_description, :responses, :date_comment)
    end
  end
   
  
end


