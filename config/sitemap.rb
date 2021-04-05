# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.heycollege.jp"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_BUCKET']}"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['AWS_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY'],
  aws_secret_access_key: ENV['AWS_SECRET_KEY'],
  aws_region: ENV['AWS_REGION'],
)

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add root_path
  add ranking_path
  lectures = Lecture.all
  lectures.each do |lecture|
    add lecture_path(lecture)
  end
  teachers = Teacher.all
  teachers.each do |teacher|
    add teacher_path(teacher)
  end
  users = User.all
  users.each do |user|
    add user_path(user)
    add edit_user_path(user)
  end
  add groups_path
  groups = Group.all
  groups.each do |group|
    add group_path(group)
    add edit_group_path(group)
  end
  add zooms_path
  add new_zoom_path
  zooms = Zoom.all
  zooms.each do |zoom|
    add edit_zoom_path(zoom)
  end
  add new_user_session_path
  add notifications_path
  news = News.all
  news.each do |a|
    add news_path(a)
  end
  add page_path('explain_confirmation')
  add page_path('privacypolicy')
  add page_path('terms')
end
