unless Rails.env.production?
  Article.destroy_all
  Page.destroy_all
  Author.destroy_all
end

about_us = "In an industry where interoperability plagues the progress of health IT, our engineers have already
figured out how to get iPhones to talk to fax machines. And we’re just getting started."

Page.where(
  title: "About Doximity",
  body: about_us,
  published: true,
  featured: true,
  author: Author.first,
  subtitle: "Page Subtitle",
  hero_image_name: 'airplane.jpg'
).first_or_create

HeroImage.where(name: "airplane.jpg").first_or_create


200.times do
  Engblog::ArticleImport.new(
    filepath: Pathname.new('db/data/articles.csv')
  ).call
end
