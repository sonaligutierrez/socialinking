class PostsController < ApplicationController
  def scraping
    begin
      post = Post.find(params[:id])
      post.send_to_scraping_comments
      post.send_to_scraping_reactions
      post.send_to_scraping_shared
      flash[:notice] = "Scraping agendado para la publicacion"
  rescue => exception
    flash[:error] = "Error al agendar scraping para la publicacion"
    end
    redirect_to admin_posts_path
  end
end
