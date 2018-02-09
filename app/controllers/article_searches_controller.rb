class ArticleSearchesController < ApplicationController
  def create
    @articles = Article.published
    if params[:query]
      @articles = @articles.where(
        id: Engblog::ArticleSearch.new(query: params[:query]).call
      )
    end

    render nothing: true
  end
end
