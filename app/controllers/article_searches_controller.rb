class ArticleSearchesController < ApplicationController
  def show
    if params[:query]
      page = params[:page] || 1

      CacheNextSearchResultPageJob.perform_later(
        query: params[:query],
        page: page,
        per_page: 5
      )

      search = Engblog::CachedArticleSearch.new(
        query: params[:query],
        page: page,
        per_page: 5
      )

      @articles = search.results.includes(:author)
      @results_for_pagination = search.pagination
    else
      redirect_to root_path
    end
  end
end
