class BlogPostsController < ApplicationController
  def index
    @posts = BlogPost.live.with_attached_hero_image
  end

  def show
    @post = BlogPost.live.with_rich_text_body_and_embeds.with_attached_hero_image
                    .includes(:travel_tip, promoted_tours: :tour).find_by!(slug: params[:slug])
  end
end
