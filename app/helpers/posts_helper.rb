# Shared by the newsletter, blog and travel tips pages.
module PostsHelper
  SITE_NAME = "Vatican Tours Inc"
  SECTION_NAMES = { "NewsletterArticle" => "Newsletter", "BlogPost" => "Blog", "TravelTip" => "Travel Tips" }.freeze

  # The section's name in breadcrumbs, e.g. "Travel Tips".
  def post_section_name(post) = SECTION_NAMES.fetch(post.class.name)

  # Home / Section / Post, as [name, url] pairs; the last one is the current page.
  def post_breadcrumbs(post)
    [ [ "Home", root_url ], [ post_section_name(post), polymorphic_url(post.class) ], [ post.title, polymorphic_url(post) ] ]
  end

  # The page title, search snippet, canonical link and structured data (Article + BreadcrumbList) for a post page.
  def post_page_meta(post)
    description = post.meta_description.presence || post.excerpt
    content_for :title, post.meta_title.presence || "#{post.title} — #{SITE_NAME}"
    content_for :description, description if description.present?
    content_for :head, tag.link(rel: "canonical", href: polymorphic_url(post))
    content_for :head, post_structured_data(post, description)
  end

  private

  def post_structured_data(post, description)
    publisher = { "@type": "Organization", name: SITE_NAME, url: root_url }
    article = {
      "@context": "https://schema.org", "@type": "Article",
      headline: post.title, description: description.presence,
      image: (rails_blob_url(post.hero_image) if post.hero_image.attached?),
      datePublished: post.published_at.iso8601, dateModified: post.updated_at.iso8601,
      mainEntityOfPage: polymorphic_url(post), author: publisher, publisher:
    }.compact
    breadcrumbs = {
      "@context": "https://schema.org", "@type": "BreadcrumbList",
      itemListElement: post_breadcrumbs(post).each_with_index.map { |(name, url), i| { "@type": "ListItem", position: i + 1, name:, item: url } }
    }
    # to_json escapes <, > and &, so the JSON can't close the script tag.
    tag.script([ article, breadcrumbs ].to_json.html_safe, type: "application/ld+json")
  end
end
