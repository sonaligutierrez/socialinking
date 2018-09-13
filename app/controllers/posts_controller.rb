class PostsController < ApplicationController
  def scraping
    begin
      ExtractDataWatirInBatchJob.set(wait: 1.second).perform_later Post.find(params[:id])
      flash[:notice] = "Scraping agendado para la publicacion"
  rescue => exception
    flash[:error] = "Error al agendar scraping para la publicacion"
    end
    redirect_to admin_posts_path
  end
end
