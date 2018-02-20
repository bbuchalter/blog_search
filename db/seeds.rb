unless Rails.env.production?
  Article.destroy_all
  Page.destroy_all
  Author.destroy_all
end

200.times do
  Engblog::ArticleImport.new(
    filepath: Pathname.new('db/data/articles.csv')
  ).call
end
