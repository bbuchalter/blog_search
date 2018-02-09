class ArticleSearchesController < ApplicationController
  def create
    @articles = Article
      .published
      .includes(:author)

    if params[:query]
      @articles = Engblog::ArticleSearch.new(
        query: params[:query]
      ).call.paginate(page: params[:page], per_page: 5)
    else
      redirect_to root_path
    end
  end
end
