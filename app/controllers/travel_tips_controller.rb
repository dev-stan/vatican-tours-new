class TravelTipsController < ApplicationController
  def index
    @posts = TravelTip.live.with_attached_hero_image
  end

  def show
    @post = TravelTip.live.with_rich_text_body_and_embeds.with_attached_hero_image
                     .includes(promoted_tours: :tour).find_by!(slug: params[:slug])
    @blog_posts = @post.blog_posts.live.with_attached_hero_image
  end
end
