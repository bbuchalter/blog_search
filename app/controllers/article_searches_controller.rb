class ArticleSearchesController < ApplicationController
  def create
    @articles = Article.all
    render nothing: true
  end
end
