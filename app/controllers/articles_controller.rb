class ArticlesController < ApplicationController
  def index
    @articles = Article.live.with_attached_hero_image
  end

  def show
    @article = Article.live.with_rich_text_body_and_embeds.with_attached_hero_image.with_attached_tour_image
                      .includes(:tour).find_by!(slug: params[:slug])
  end
end
