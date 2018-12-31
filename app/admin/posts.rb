ActiveAdmin.register Post do
  config.filters = false
  config.batch_actions = false

  menu label: proc { I18n.t("active_admin.posts") }, priority: 2
  menu parent: "Publicadores"
  actions :all
  permit_params :post_creator_id, :date, :post_date, :url, :title, :get_comments, :get_reactions, :get_shared

  index do
    render "admin/posts/index_posts", context: self
  end

  show do
    render "admin/posts/show_post", context: self
  end

  form do |f|
    f.inputs do
      f.input :post_creator, label: "Publicador", as: :select, collection: PostCreator.all.map { |u| ["#{u.fan_page}", u.id] }
      f.input :url
      f.input :get_comments, label: "Obtener Comentarios"
      f.input :get_reactions, label: "Obtener Reacciones"
      f.input :get_shared, label: "Obtener Compartidos"
    end
    f.actions
  end
  member_action :comments, method: :get do
    @post = Post.find(params[:id])
    # @post_comments = @post.post_comments.joins(:category).where("categories.name LIKE ?", "Uncategorized")
    @post_comments = @post.post_comments
    @post_comments = @post_comments.page(params[:page] || 1).per(10)
    @categorias = []
    @categorias.push(["Todo", 0])
    Category.all.map { |c| @categorias.push([c.name, c.id]) }
  end

  member_action :new_comment, method: :get do
    @post = Post.find(params[:id])
    @post_comments = PostComment.new
    @post_comments.post = @post

  end

  member_action :update_comments_in_batches, method: :put do
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments
    @post_comments = @post_comments.where(category_id: params[:category_id]) if params[:category_id].to_i > 0
    @post_comments.update(category_id: params[:new_category_id])
    render body: nil
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
    @post_comments = @post.post_comments
    @post_comments = @post_comments.where(category_id: params[:category_id]) if params[:category_id].to_i > 0
    @post_comments = @post_comments.page(params[:page] || 1).per(10)
    @categorias = []
    @categorias.push(["Todo", 0])
    Category.all.map { |c| @categorias.push([c.name, c.id]) }
    respond_to do |format|
      format.js
    end
  end

  collection_action :search, method: :get do
    @posts = Post.search(params[:post_creator_id], params[:column_order], params[:type_order])
    respond_to do |format|
      format.js
    end
  end

  collection_action :search_comments, method: :get do
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments
    @post_comments = @post_comments.where(category_id: params[:category_id]) if params[:category_id] != nil
    respond_to do |format|
      format.js
    end
  end

  collection_action :search_reactions, method: :get do
    @post = Post.find(params[:id])
    @post_reactions = @post.post_reactions
    @post_reactions = @post_reactions.where(reaction: params[:reaction]) if params[:reaction] != nil
    respond_to do |format|
      format.js
    end
  end

  collection_action :refresh_section, method: :get do
    @date_hour = "A fecha de hoy a las #{Time.now.strftime("%H:%M")}"
    @type = params[:type]
    respond_to do |format|
      format.js
    end
  end

  collection_action :import_csv, method: :get do
    # post_comments = PostComment.where(post_id: params[:post_id]).includes(:facebook_user).order("id ASC")
    posts = Post.all
    csv = CSV.generate(encoding: "UTF-8") do |csv|
      csv << [ "Id", "Date", "post_date", "created_at", "updated_at", "post_creator",
      "url", "title", "description", "image",
      "get_comments", "get_reactions", "get_shared"]
      posts.each do |p|
        commentarry = [ p.id, p.date, p.post_date, p.created_at,  p.updated_at, p.post_creator&.fan_page,
        p.url, p.title, p.description, p.image, p.get_comments, p.get_reactions, p.get_shared]
        csv << commentarry
      end
    end
    send_data csv.encode("UTF-8"), type: "text/csv; charset=windows-1251; header=present", disposition: "attachment; filename=posts.csv"
  end



  controller do

    def edit
      @page_title = "Editar Publicacion # #{resource.id}"
    end

    def index
      @posts = Post.all.page(params[:page]).per(10)
      @page_title = "Publicaciones (#{@posts.count})"
      @creators = []
      @columns = [["Fecha de publicación", "post_date"], ["Titulo", "title"]]
      @creators.push(["Todas las publicaciones", 0])
      PostCreator.all.map { |p| @creators.push([p.fan_page, p.id]) }
      @select = params[:post_creator_id] || 0
      @select_type_order = "DESC"
    end

    def show
      @post = Post.find(params[:id])
      @page_title = "#{@post.post_creator.try(:fan_page)} / #{@post.title}"
      @categorias = Category.all
      @reactions = [["Me Gusta", "_3j7l"], ["Me Enoja", "_3j7q"], ["Me Encanta", "_3j7m"], ["Me Entristece", "_3j7r"], ["Me Sorprende", "_3j7n"], ["Me Divierte", "_3j7o"]]
      @post_shared = @post.post_shared
      @post_comments = @post.post_comments
      @post_reactions = @post.post_reactions
    end


    def comment_params
      params.require(:post_comment).permit(:date, :comment, :facebook_user_id, :category_id, :id_comment, :reactions, :reactions_description, :responses, :date_comment)
    end
  end


end
