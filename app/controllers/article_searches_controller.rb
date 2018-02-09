class ArticleSearchesController < ApplicationController
  def create
    @articles = Article
      .published
      .includes(:author)

    if params[:query]
      @articles = @articles.where(
        id: Engblog::ArticleSearch.new(query: params[:query]).call
      )
    end
    @articles = @articles.paginate(page: params[:page], per_page: 5)
  end
end
